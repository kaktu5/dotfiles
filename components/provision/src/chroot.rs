use std::{
  fs::{self, File},
  io::{Read as _, Write as _},
  panic::{self, AssertUnwindSafe},
  path::Path,
};

use misstep::{Result, ResultExt as _, bail};
use nix::{
  fcntl::OFlag,
  libc::_exit,
  mount::{MsFlags, mount},
  sched::{CloneFlags, unshare},
  sys::wait::{WaitStatus, waitpid},
  unistd::{ForkResult, chdir, chroot, fork, pipe2},
};

use crate::bind;

fn enter_chroot(root: &Path) -> Result<()> {
  unshare(CloneFlags::CLONE_NEWNS | CloneFlags::CLONE_NEWUTS).context("creating a private mount namespace")?;
  mount(
    None::<&str>,
    "/",
    None::<&str>,
    MsFlags::MS_REC | MsFlags::MS_PRIVATE,
    None::<&str>,
  )
  .context("making the mount tree private")?;

  for d in ["dev", "sys", "proc"] {
    let dst = root.join(d);
    fs::create_dir_all(&dst).with_context(|| format!("creating {}", dst.display()))?; // 0755 via umask
    bind(Path::new("/").join(d), &dst)?;
  }

  chroot(root).with_context(|| format!("chrooting into {}", root.display()))?;
  chdir("/").context("changing directory to the new root")?;
  Ok(())
}

pub fn in_chroot<F>(root: &Path, f: F) -> Result<()>
where
  F: FnOnce() -> Result<()>,
{
  // CLOEXEC keeps the write end out of processes spawned inside the chroot. Otherwise a
  // lingering daemon would hold the pipe open and the parent's read would never see EOF.
  let (rx, tx) = pipe2(OFlag::O_CLOEXEC).context("creating the error pipe")?;

  // SAFETY: no other threads exist here, since every earlier helper joins its threads.
  match unsafe { fork() }.context("forking the chroot step")? {
    ForkResult::Child => {
      drop(rx);
      let outcome = panic::catch_unwind(AssertUnwindSafe(|| enter_chroot(root).and_then(|()| f())));
      let code = match outcome {
        Ok(Ok(())) => 0,
        Ok(Err(e)) => {
          // Best effort: if this write fails, the parent still reports the exit code.
          drop(write!(File::from(tx), "{e}"));
          1
        },
        // The panic hook has already printed the message.
        Err(_) => 101,
      };
      // SAFETY: `_exit` never returns. It skips the parent's destructors and atexit
      // handlers, which must not run in the child.
      unsafe { _exit(code) }
    },
    ForkResult::Parent { child } => {
      drop(tx);
      let mut msg = String::new();
      drop(File::from(rx).read_to_string(&mut msg));

      match waitpid(child, None).context("waiting for the chroot step")? {
        WaitStatus::Exited(_, 0) => Ok(()),
        WaitStatus::Exited(..) if !msg.is_empty() => bail!("{msg}"),
        WaitStatus::Exited(_, code) => bail!("step inside the chroot failed with exit code {code}"),
        WaitStatus::Signaled(_, sig, _) => bail!("step inside the chroot was killed by signal {sig:?}"),
        WaitStatus::Stopped(_, sig) => bail!("step inside the chroot was stopped by signal {sig:?}"),
        status @ (WaitStatus::Continued(_)
        | WaitStatus::StillAlive
        | WaitStatus::PtraceEvent(..)
        | WaitStatus::PtraceSyscall(_)) => bail!("step inside the chroot failed ({status:?})"),
      }
    },
  }
}
