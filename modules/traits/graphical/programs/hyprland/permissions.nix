{pkgs, ...}: let
  xdph' = pkgs.xdg-desktop-portal-hyprland + /libexec/xdg-desktop-portal-hyprland;
in {
  kkts.programs.hyprland.permissions = {
    plugin = {
      binaries = [".*"];
      mode = "deny";
    };

    screencopy = {
      binaries = [xdph'];
      mode = "allow";
    };
  };
}
