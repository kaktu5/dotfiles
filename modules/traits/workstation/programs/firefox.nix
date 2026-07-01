{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (pkgs) firefox;
in {
  persistence.users.${userName}.directories = [
    ".local/cache/mozilla/firefox"
    ".config/mozilla/firefox"
  ];

  users.users.${userName}.packages = [firefox];
}
