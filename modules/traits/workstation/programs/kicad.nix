{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (pkgs) kicad;
in {
  persistence.users.${userName}.directories = [
    ".local/cache/kicad"
    ".local/data/kicad"
    ".config/kicad"
  ];
  
  users.users.${userName}.packages = [kicad];
}
