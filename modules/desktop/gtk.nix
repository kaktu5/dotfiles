# TODO:
# - papirus-folders
{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
in {
  home-manager.users.${username} = {
    stylix.targets.gtk.enable = true;
    gtk = {
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Classic";
        package = pkgs.bibata-cursors;
      };
    };
  };
}
