{
  config,
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (builtins) attrNames toString;
  inherit (lib) concatMapStringsSep concatStringsSep imap0 mapAttrsToList pipe;
  inherit (pkgs) writeText;
  inherit (theme) colors fonts windowManager;
  binds = import ./binds.nix;
  binds' = writeText "hyprland-binds" (pipe binds [
    attrNames
    (map (type:
      concatMapStringsSep "\n"
      (bind: "${type} = ${bind}")
      binds.${type}))
    (concatStringsSep "\n")
  ]);
  scratchpads = pipe (import ./scratchpads.nix) [
    (mapAttrsToList (bind: action: {inherit bind action;}))
    (imap0 (index: entry: ''
      bind = ${entry.bind}, togglespecialworkspace, ${toString index}
      workspace = special:${toString index}, ${entry.action}
    ''))
    (concatStringsSep "\n")
  ];
  monitors = import ./monitors.nix {inherit config lib;};
  startup = import ./startup.nix {inherit config lib pkgs;};
  hyprland-config = writeText "hyprland-config" ''
    plugin = ${pkgs.hyprlandPlugins.hypr-dynamic-cursors}/lib/libhypr-dynamic-cursors.so

    source = ${./hyprland.conf}
    source = ${binds'}

    general {
      border_size = ${toString windowManager.borderSize}
      col.active_border = rgb(${colors.fg3})
      col.inactive_border = rgb(${colors.bg3})
      gaps_in = ${toString windowManager.gapsSize}
      gaps_out = ${toString (windowManager.gapsSize * 2)}
    }
    misc {
      background_color = rgb(${colors.bg0})
      font_family = ${fonts.sansSerif.name}
    }

    ${scratchpads}
    ${monitors}

    exec-once = ${startup}

    exec-once = uwsm finalize
  '';
in {
  imports = [./screenshot.nix];
  kkts.sessionVariables = {
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland,x11,*";
    HYPRLAND_CONFIG = hyprland-config;
    NIXOS_OZONE_WL = 1;
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    SDL_VIDEODRIVER = "wayland";
    XCURSOR_SIZE = 24;
  };
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };
  home.packages = [pkgs.wl-clipboard];
}
