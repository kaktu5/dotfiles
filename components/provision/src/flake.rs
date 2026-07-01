use std::str::FromStr;

use misstep::{Report, Result, bail, ensure, report};

#[derive(Clone, Debug)]
pub struct FlakeRef {
  uri: String,
  host: String,
}

impl FlakeRef {
  pub fn uri(&self) -> &str {
    &self.uri
  }

  pub fn installable(&self) -> String {
    format!(
      "{}#nixosConfigurations.\"{}\".config.system.build.toplevel",
      self.uri, self.host
    )
  }
}

impl FromStr for FlakeRef {
  type Err = Report;

  fn from_str(s: &str) -> Result<Self> {
    let (uri, host) = s
      .split_once('#')
      .ok_or_else(|| report!("missing `#host`: name the NixOS configuration"))?;

    ensure!(!uri.is_empty(), "empty flake reference before `#`");
    ensure!(!host.is_empty(), "empty configuration name after `#`");

    if let Some(c) = host
      .chars()
      .find(|c| !(c.is_ascii_alphanumeric() || matches!(c, '-' | '_' | '.')))
    {
      bail!("invalid character `{c}` in configuration name");
    }

    Ok(Self {
      uri: uri.to_owned(),
      host: host.to_owned(),
    })
  }
}
