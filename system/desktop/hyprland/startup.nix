{
  config,
  lib,
  pkgs,
}: let
  inherit (config.kkts.hardware.monitors) primaryMonitor;
  inherit (lib) makeBinPath;
  inherit (pkgs) writeShellScript;
in
  writeShellScript "hyprland-startup" ''
    PATH=${makeBinPath (with pkgs; [
      cliphist
      eww
      hyprland
      jq
      swww
      udiskie
      uwsm
      wl-clipboard
    ])}

    # uwsm app -- eww o statusbar --screen \
    #   "$(hyprctl monitors -j | jq -r '.[] | select(.name == "${primaryMonitor}") | .id')"

    SWWW_TRANSITION="none"
    uwsm app -- swww-daemon &
    uwsm app -- swww img ~/pictures/wallpapers/default

    uwsm app -- wl-paste --watch cliphist store

    uwsm app -- udiskie
  ''
