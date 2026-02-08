{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.generators) toINI;
  inherit (lib.kkts.formats) hyprlang;
  inherit (pkgs.kdePackages) xdg-desktop-portal-kde;
in {
  xdg.portal.extraPortals = [xdg-desktop-portal-kde];

  hjem.users.${userName}.xdg.config.files = {
    "xdg-desktop-portal/hyprland-portals.conf" = {
      generator = toINI {};
      value.preferred = {
        default = "hyprland";
        "org.freedesktop.impl.portal.FileChooser" = "kde";
      };
    };

    "hypr/xdph.conf" = {
      generator = hyprlang.generate {};
      value.screencopy.allow_token_by_default = true;
    };
  };
}
