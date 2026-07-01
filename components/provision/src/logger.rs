use std::{
  fmt::Arguments,
  io::{self, BufRead as _, BufReader, Read, Write as _},
  process::{Command, ExitStatus, Stdio},
  thread,
};

use owo_colors::{OwoColorize as _, Style};

const TAG: Style = Style::new().cyan();
const ERROR: Style = Style::new().red();
const OUTPUT: Style = Style::new().bright_black();

#[expect(clippy::unwrap_used, reason = "panics if writing to stderr fails")]
fn emit(args: Arguments<'_>) {
  writeln!(io::stderr().lock(), "{args}").unwrap();
}

pub fn print_log(phase: &str, args: Arguments<'_>) {
  emit(format_args!("{} {args}", format_args!("[{phase}]").style(TAG)));
}

pub fn print_error(phase: &str, args: Arguments<'_>) {
  emit(format_args!(
    "{} {} {}",
    format_args!("[{phase}]").style(TAG),
    "[error]".style(ERROR),
    args.style(ERROR),
  ));
}

#[macro_export]
macro_rules! make_logger {
  ($phase:expr) => {
    $crate::make_logger!(@define ($) $phase);
  };
  (@define ($d:tt) $phase:expr) => {
    #[allow(clippy::allow_attributes, clippy::allow_attributes_without_reason, unused_macros)]
    macro_rules! log {
      ($d($d arg:tt)*) => {
        $crate::logger::print_log($phase, format_args!($d($d arg)*))
      };
    }
    #[allow(unused_macros)]
    #[allow(clippy::allow_attributes, clippy::allow_attributes_without_reason, unused_macros)]
    macro_rules! error {
      ($d($d arg:tt)*) => {
        $crate::logger::print_error($phase, format_args!($d($d arg)*))
      };
    }
  };
}

#[expect(clippy::unwrap_used, reason = "panics if writing to stderr fails")]
pub fn forward_dimmed<R>(reader: R)
where
  R: Read,
{
  let mut buf_reader = BufReader::new(reader);
  let mut line = Vec::new();
  let mut out = Vec::new();

  loop {
    line.clear();
    match buf_reader.read_until(b'\n', &mut line) {
      Ok(0) | Err(_) => break,
      Ok(_) => {},
    }

    let body = line.strip_suffix(b"\n").unwrap_or(&line);

    out.clear();
    write!(out, "  {}", OUTPUT.prefix_formatter()).unwrap();
    out.extend_from_slice(body);
    writeln!(out, "{}", OUTPUT.suffix_formatter()).unwrap();

    io::stderr().write_all(&out).unwrap();
  }
}

fn check(status: ExitStatus) -> io::Result<()> {
  if status.success() {
    Ok(())
  } else {
    Err(io::Error::other(format!("command exited with status {status}")))
  }
}

pub fn run_logged(cmd: &mut Command) -> io::Result<()> {
  cmd.stdout(Stdio::piped()).stderr(Stdio::piped());

  let mut child = cmd.spawn()?;
  let stdout = child.stdout.take();
  let stderr = child.stderr.take();

  let status = thread::scope(|s| {
    if let Some(out) = stdout {
      s.spawn(move || forward_dimmed(out));
    }
    if let Some(err) = stderr {
      s.spawn(move || forward_dimmed(err));
    }
    child.wait()
  })?;

  check(status)
}

pub fn run_captured(cmd: &mut Command) -> io::Result<Vec<u8>> {
  cmd.stdout(Stdio::piped()).stderr(Stdio::piped());

  let mut child = cmd.spawn()?;
  let mut stdout = child
    .stdout
    .take()
    .ok_or_else(|| io::Error::other("stdout was not captured"))?;
  let stderr = child.stderr.take();

  let (out, status) = thread::scope(|s| {
    if let Some(err) = stderr {
      s.spawn(move || forward_dimmed(err));
    }
    let mut out = Vec::new();
    let read = stdout.read_to_end(&mut out);
    let status = child.wait();
    read?;
    Ok::<_, io::Error>((out, status?))
  })?;

  check(status)?;
  Ok(out)
}
