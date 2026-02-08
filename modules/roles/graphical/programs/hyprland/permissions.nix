{pkgs, ...}: let
  xdph = pkgs.xdg-desktop-portal-hyprland + /libexec/xdg-desktop-portal-hyprland;
in {
  kkts.programs.hyprland.settings.permission = [
    [".*" "plugin" "deny"]
    [xdph "screencopy" "allow"]
  ];
}
