{config, ...}: let
  inherit (config.kkts.theme.colors.hex) bg0 bg1 bg3;
  inherit (config.kkts.theme.fonts.fonts) sansSerif;

  rgb = hex: "rgb(${hex})";
in {
  kkts.programs.hyprland.settings = {
    exec-once = ["uwsm finalize"];

    general = {
      border_size = 3;

      gaps_in = 4;
      gaps_out = 8;
      float_gaps = 8;

      "col.inactive_border" = rgb bg1;
      "col.active_border" = rgb bg3;

      allow_tearing = true;

      snap = {
        enabled = true;
        window_gap = 8;
        monitor_gap = 8;
        respect_gaps = true;
      };
    };

    decoration = {
      blur.enabled = false;
      shadow.enabled = false;
    };

    animations = {
      bezier = [["easeout" 0.25 1 0.5 1]];
      animation = [
        ["windows" 1 2 "easeout" "popin"]
        ["layers" 1 2 "default"]
        ["fade" 1 2 "default"]
        ["border" 1 3 "default"]
        ["workspaces" 1 3 "easeout" "slidevert"]
        ["monitorAdded" 0 null null]
      ];
    };

    input = {
      kb_layout = "pl";
      touchpad = {
        natural_scroll = true;
        drag_lock = 1; # enabled with timeout
      };
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;

      font_family = sansSerif.name;

      vrr = 2; # fullscreen only

      animate_manual_resizes = true;

      enable_swallow = true;
      swallow_regex = "^(app-com\\.mitchellh\\.ghostty)$";

      initial_workspace_tracking = 1; # single-shot

      background_color = rgb bg0;

      on_focus_under_fullscreen = 1; # takes over

      middle_click_paste = false;

      size_limits_tiled = true;
    };

    xwayland.force_zero_scaling = true;

    cursor.inactive_timeout = 1;

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;

      enforce_permissions = true;
    };

    dwindle.preserve_split = true;
  };
}
