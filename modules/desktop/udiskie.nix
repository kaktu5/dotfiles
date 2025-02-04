{config, ...}: let
  inherit (config.kkts.system) username;
in {
  services.udisks2.enable = true;
  home-manager.users.${username}.services.udiskie = {
    enable = true;
    tray = "never";
  };
}
