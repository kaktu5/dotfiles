{config, ...}: let
  inherit (config.kkts.colors) bg0 bg3 fg2;
  inherit (config.kkts.system) username;
  cursor = config.home-manager.users.${username}.gtk.cursorTheme.name;
  font = config.home-manager.users.${username}.stylix.fonts.monospace.name;
in {
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    env = [
      "XCURSOR_THEME, ${cursor}"
      "XCURSOR_SIZE, 24"
    ];
    general = {
      border_size = 2;
      gaps_in = 4;
      gaps_out = 8;
      "col.active_border" = "rgb(${fg2})";
      "col.inactive_border" = "rgb(${bg3})";
    };
    decoration = {
      shadow.enabled = false;
      dim_special = 0.0;
      blur = {
        size = 4;
        passes = 2;
        noise = 0.033;
        popups = true;
      };
    };
    animations = {
      first_launch_animation = false;
      bezier = ["a, 0, 0, 0, 1" "b, 0, 1, 0, 1"];
      animation = [
        "windows, 1, 2, a, popin"
        "fade, 1, 5, default"
        "border, 1, 5, default"
        "workspaces, 1, 5, b, slidevert"
      ];
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      font_family = font;
      background_color = "rgb(${bg0})";
    };
  };
}
