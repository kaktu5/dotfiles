{
  config,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (pkgs) firefox;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = [
    "${xdg.cache.directory}/mozilla/firefox"
    "${xdg.config.directory}/mozilla/firefox"
  ];

  users.users.${userName}.packages = [firefox];
}
