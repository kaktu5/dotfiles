{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (lib) getExe;
  inherit (pkgs) writeShellScriptBin;
  startup = let
    eww = getExe pkgs.eww;
    hyprsunset = getExe pkgs.hyprsunset;
    polkitAgent = "${pkgs.polkit_gnome}/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1";
    udiskie = "${pkgs.udiskie}/bin/udiskie";
  in
    getExe (writeShellScriptBin "startup" ''
      ${polkitAgent} &
      ${udiskie} &
      ${eww} open statusbar --screen 0 &
      (while true; do
        hour=$(date +%H)
        [ $hour -ge 18 ] || [ $hour -lt 8 ] && ${hyprsunset} -t 5000
        sleep 60
      done) &
    '');
in {
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    exec-once = ["${startup}"];
    env = [
      "XDG_CURRENT_DESKTOP, Hyprland"
      "XDG_SESSION_TYPE, wayland"
      "XDG_SESSION_DESKTOP, Hyprland"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
    ];
    general = {
      allow_tearing = true;
      snap.enabled = true;
    };
    misc = {
      animate_manual_resizes = true;
      initial_workspace_tracking = 1;
      middle_click_paste = false;
    };
    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };
    binds.workspace_center_on = 1;
    cursor.inactive_timeout = 1;
    dwindle.preserve_split = true;
    xwayland.force_zero_scaling = true;
  };
}
