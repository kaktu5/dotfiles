mod chroot;
mod flake;
mod logger;

use std::{
  collections::BTreeMap,
  env,
  ffi::{OsStr, OsString},
  fs::{self, DirBuilder},
  os::unix::{fs::DirBuilderExt as _, process::CommandExt as _},
  path::{self, Path, PathBuf},
  process::{Command, ExitCode},
};

use flake::FlakeRef;
use misstep::{Result, ResultExt as _, ensure, report};
use nix::{
  mount::{MntFlags, MsFlags, mount, umount2},
  unistd::geteuid,
};
use pound::Parse;
use serde::Deserialize;

use crate::logger::{run_captured, run_logged};

crate::make_logger!("install");

const SUBSTITUTER: &str = "auto?trusted=1";

const SYSTEM_PROFILE: &str = "/nix/var/nix/profiles/system";
const SYSTEM_ACTIVATE: &str = "/nix/var/nix/profiles/system/activate";
const SYSTEM_SWITCH_TO_CONFIGURATION: &str = "/nix/var/nix/profiles/system/bin/switch-to-configuration";
const SYSTEM_SW_BIN: &str = "/nix/var/nix/profiles/system/sw/bin";

/// Provision a NixOS system
#[derive(Parse)]
#[pound(required_group = source)]
struct Cli {
  /// Root of the target filesystem
  #[pound(long, default = "/mnt")]
  root: PathBuf,

  /// Flake to provision from, as URI#host
  #[pound(long, group = source, value_name = "URI#HOST", parse = str::parse::<FlakeRef>)]
  flake: Option<FlakeRef>,
  /// Prebuilt system closure to provision from, as a store path
  #[pound(long, group = source)]
  closure: Option<PathBuf>,
}

fn main() -> ExitCode {
  match run() {
    Ok(()) => {
      log!("installation finished");
      ExitCode::SUCCESS
    },
    Err(e) => {
      error!("{e}");
      ExitCode::FAILURE
    },
  }
}

fn run() -> Result<()> {
  let mut cli = Cli::parse();

  if !geteuid().is_root() {
    if let Some(ref flake) = cli.flake {
      log!("building the flake in {}", flake.uri());
      let closure_path = build_flake_as_user(flake)?;
      cli.flake = None;
      cli.closure = Some(closure_path);
    }
    return reexec_as_root(&cli);
  }

  let root = path::absolute(&cli.root).with_context(|| format!("resolving {}", cli.root.display()))?;
  ensure!(root.exists(), "mount point {} doesn't exist", root.display());

  install_profile(&cli, &root)?;

  chroot::in_chroot(&root, || {
    activate()?;
    install_boot_loader(&root)
  })
}

fn install_profile(cli: &Cli, root: &Path) -> Result<()> {
  #[expect(
    clippy::unreachable,
    reason = "`pound` ensures that either --closure or --flake is always provided"
  )]
  let installable: OsString = match (cli.closure.as_ref(), cli.flake.as_ref()) {
    (Some(closure), None) => closure.as_os_str().to_owned(),
    (None, Some(flake)) => {
      log!("building the flake in {}", flake.uri());
      flake.installable().into()
    },
    _ => unreachable!(),
  };

  let mut c = Command::new("nix");
  c.arg("build")
    .arg(installable)
    .arg("--no-link")
    .args([OsStr::new("--profile"), root.join(SYSTEM_PROFILE).as_os_str()])
    .args([OsStr::new("--store"), root.as_os_str()])
    .args(["--extra-substituters", SUBSTITUTER]);

  run_logged(&mut c).context("building the system profile")?;

  Ok(())
}

fn activate() -> Result<()> {
  log!("Running system activation script");

  DirBuilder::new()
    .recursive(true)
    .mode(0o755)
    .create("/etc")
    .context("creating /etc")?;

  let mut cmd = Command::new(SYSTEM_ACTIVATE);
  cmd.env_clear().env("PATH", SYSTEM_SW_BIN).env("IN_NIXOS_ENTER", "1");

  run_logged(&mut cmd).context("running the system activation script")?;

  Ok(())
}

fn install_boot_loader(root: &Path) -> Result<()> {
  log!("installing the boot loader");

  fs::create_dir_all(root).with_context(|| format!("creating {}", root.display()))?;
  bind("/", root)?;

  let mut cmd = Command::new(SYSTEM_SWITCH_TO_CONFIGURATION);
  cmd
    .arg("boot")
    .env_clear()
    .env("PATH", SYSTEM_SW_BIN)
    .env("NIXOS_INSTALL_BOOTLOADER", "1");

  let result = run_logged(&mut cmd).context("installing the boot loader");

  let cleanup = umount2(root, MntFlags::MNT_DETACH)
    .with_context(|| format!("unmounting {}", root.display()))
    .erase()
    .and_then(|()| {
      fs::remove_dir(root)
        .with_context(|| format!("removing {}", root.display()))
        .erase()
    });
  if let Err(e) = cleanup {
    error!("cleanup failed: {e}");
  }

  result.map_err(Into::into)
}

fn build_flake_as_user(flake: &FlakeRef) -> Result<PathBuf> {
  #[derive(Deserialize)]
  struct NixBuildOutput {
    outputs: BTreeMap<String, String>,
  }

  let mut c = Command::new("nix");
  c.arg("build").arg(flake.installable()).arg("--no-link").arg("--json");

  let stdout = run_captured(&mut c).context("running `nix build`")?;

  let builds: Vec<NixBuildOutput> =
    serde_json::from_slice(&stdout).context("failed to parse JSON output from `nix build --json`")?;

  let build = builds
    .into_iter()
    .next()
    .ok_or_else(|| report!("nix build returned an empty JSON array"))?;

  let store_path_str = build
    .outputs
    .get("out")
    .or_else(|| build.outputs.values().next())
    .ok_or_else(|| report!("nix build JSON output contained no store paths"))?;

  let path = PathBuf::from(store_path_str);
  ensure!(
    path.exists(),
    "returned store path does not exist on disk: {}",
    path.display()
  );

  Ok(path)
}

fn reexec_as_root(cli: &Cli) -> Result<()> {
  let mut chdir = OsString::from("--chdir=");
  chdir.push(env::current_dir().context("getting the current directory")?);

  let mut c = Command::new("run0");
  c.args([
    "--property=Delegate=yes",
    "--property=DelegateSubgroup=supervisor",
    "--background=",
  ])
  .arg(chdir);

  for var in ["PATH", "TERM"] {
    if env::var_os(var).is_some() {
      c.arg(format!("--setenv={var}"));
    }
  }

  c.arg(env::current_exe().context("locating the running executable")?);

  c.arg("--root").arg(&cli.root);
  if let Some(ref closure) = cli.closure {
    c.arg("--closure").arg(closure);
  }

  Err::<(), _>(c.exec()).context("cannot run run0").erase()
}

#[inline]
pub fn bind<S, D>(src: S, dest: D) -> Result<()>
where
  S: AsRef<Path>,
  D: AsRef<Path>,
{
  let (src_ref, dest_ref) = (src.as_ref(), dest.as_ref());

  mount(
    Some(src_ref),
    dest_ref,
    None::<&str>,
    MsFlags::MS_BIND | MsFlags::MS_REC,
    None::<&str>,
  )
  .with_context(|| format!("bind-mounting {} onto {}", src_ref.display(), dest_ref.display()))?;

  Ok(())
}
