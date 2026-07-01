{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (pkgs) kicad;
in {
  persistence.users.${userName}.directories = [
    ".config/kicad"
    ".local/cache/kicad"
    ".local/data/kicad"
  ];

  users.users.${userName}.packages = [kicad];
}
