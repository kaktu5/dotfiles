{config, ...}: let
  inherit (config.kkts.system) username;
in {
  home-manager.users.${username} = {
    programs.btop.enable = true;
    xdg.configFile."btop/btop.conf".source = ../../resources/configs/btop.conf;
  };
}
