{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.programs.hyprland) settings;
  inherit (lib.kkts.formats) hyprlang;
in {
  imports = [
    ./binds.nix
    ./monitors.nix
    ./permissions.nix
    ./settings.nix
    ./smartgaps.nix
    ./xdg-desktop-portal.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  hjem.users.${userName} = {
    environment.sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
    };

    xdg.config.files."hypr/hyprland.conf" = {
      generator = hyprlang.generate {priorityKeys = ["bezier" "name" "output"];};
      value = settings;
    };
  };
}
