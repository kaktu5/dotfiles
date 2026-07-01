{
  config,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (pkgs) kicad;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = [
    "${xdg.cache.directory}/kicad"
    "${xdg.config.directory}/kicad"
    "${xdg.data.directory}/kicad"
  ];
  
  users.users.${userName}.packages = [kicad];
}
