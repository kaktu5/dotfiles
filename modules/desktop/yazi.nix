{config, ...}: let
  inherit (config.kkts.system) username;
in {
  home-manager.users.${username}.programs.yazi = {
    enable = true;
  };
}
