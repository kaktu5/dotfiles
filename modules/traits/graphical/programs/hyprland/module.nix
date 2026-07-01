{
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment.sessionVariables) XCURSOR_SIZE;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.programs.hyprland) finalConfig;
  inherit (config.kkts.theme.colors) hex';
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.nixexprs.legacyPackages.${system}) breezex-cursor;

  breezex-cursor' = breezex-cursor.override {
    baseColor = hex'.bg0;
    outlineColor = hex'.fg0;
    watchColor = hex'.bg0;
    xcursorSizes = [XCURSOR_SIZE];
  };

  HYPRLAND_CONFIG = pkgs.writeText "hyprland-config.lua" finalConfig;
in {
  imports = [
    ./animations.nix
    ./binds.nix
    ./config.nix
    ./monitors.nix
    ./permissions.nix
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

    XCURSOR_SIZE = 24;
    XCURSOR_THEME = "BreezeX";

    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11,*";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
  };
}
