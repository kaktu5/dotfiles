{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment.sessionVariables) XCURSOR_SIZE;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.programs.hyprland) settings;
  inherit (config.kkts.theme.colors) hex';
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.nixexprs.legacyPackages.${system}) breezex-cursor;
  inherit (lib.kkts.formats) hyprlang;
  inherit (pkgs.writers) writeText;

  breezex-cursor' = breezex-cursor.override {
    baseColor = hex'.bg0;
    outlineColor = hex'.fg0;
    watchColor = hex'.bg0;
    xcursorSizes = [XCURSOR_SIZE];
  };

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

  users.users.${userName}.packages = [breezex-cursor'];

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
