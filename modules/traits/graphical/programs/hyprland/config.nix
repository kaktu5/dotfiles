{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.theme.colors) hex';
  inherit (config.kkts.theme.fonts.fonts) sansSerif;
  inherit (lib.meta) getExe;
  inherit (pkgs) uwsm;
in {
  kkts.programs.hyprland = {
    events."hyprland.start" = "function() hl.exec_cmd('${getExe uwsm} finalize') end";

    config = {
      general = {
        border_size = 3;

        gaps_in = 4;
        gaps_out = 8;
        float_gaps = 8;

        "col.inactive_border" = hex'.bg1;
        "col.active_border" = hex'.bg3;

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

        background_color = hex'.bg0;

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
  };
}
