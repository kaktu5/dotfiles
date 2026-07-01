{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (pkgs.writers) writeTOML;

  CARGO_HOME = "${home}/.local/share/cargo";
in {
  persistence.users.${userName}.directories = [".local/share/cargo"];

  hjem.users.${userName} = {
    environment.sessionVariables = {inherit CARGO_HOME;};

    xdg.data.files."cargo/config.toml" = {
      generator = writeTOML "cargo-config.toml";
      value = {
        alias.lint = "clippy --all-targets -- -D warnings";

        cache.auto-clean-frequency = "1 week";
      };
    };
  };
}
