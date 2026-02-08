{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.programs.hyprland) settings;
  inherit (lib.kkts.formats) hyprlang;
  inherit (pkgs.writers) writeText;

  HYPRLAND_CONFIG =
    settings
    |> hyprlang.generate {priorityKeys = ["bezier" "name" "output"];}
    |> writeText "hyprland-conf";
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

  hjem.users.${userName}.environment.sessionVariables = {
    inherit HYPRLAND_CONFIG;

    XCURSOR_SIZE = 32;
    XCURSOR_THEME = "BreezeX";

    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
  };
}
