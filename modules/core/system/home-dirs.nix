{config, ...}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
in {
  hjem.users.${userName}.xdg.cache.directory = home + "/.local/cache";
}
