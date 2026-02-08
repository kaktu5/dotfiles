{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.kkts.hyprland) bind dsp;
  inherit (lib.lists) foldl' range;
  inherit (lib.meta) getExe;
  inherit (pkgs) ghostty rofi uwsm;

  ghostty' = "${getExe ghostty} +new-window";
  rofi' = "${getExe rofi} -show drun -run-command 'uwsm app -- {cmd}'";

  cfg = config.kkts.programs.hyprland.config;
in {
  kkts.programs.hyprland = {
    binds =
      {
        "SUPER + RETURN" = dsp "exec_raw" ghostty';
        "SUPER + SPACE" = dsp "exec_raw" rofi';

        "SUPER + C" = dsp "window.close" null;
        "SUPER + O" = dsp "window.fullscreen" {mode = "maximized";};
        "SUPER + F" = [
          (dsp "window.float" {})
          (dsp "window.center" {})
        ];
        "SUPER + SHIFT + F" = dsp "window.center" {};
        "SUPER + R" = dsp "layout" "togglesplit";
        "SUPER + SHIFT + ESCAPE" = dsp "exec_raw" "${getExe uwsm} stop";

        "SUPER + TAB" = dsp "window.cycle_next" {};
        "SUPER + SHIFT + TAB" = dsp "window.cycle_next" {next = false;};

        "SUPER + H" = dsp "focus" {direction = "l";};
        "SUPER + J" = dsp "focus" {direction = "d";};
        "SUPER + K" = dsp "focus" {direction = "u";};
        "SUPER + L" = dsp "focus" {direction = "r";};

        "SUPER + SHIFT + H" = dsp "window.move" {direction = "l";};
        "SUPER + SHIFT + J" = dsp "window.move" {direction = "d";};
        "SUPER + SHIFT + K" = dsp "window.move" {direction = "u";};
        "SUPER + SHIFT + L" = dsp "window.move" {direction = "r";};

        "SUPER + CTRL + H" =
          bind {repeating = true;}
          <| dsp "window.resize" {
            x = -20;
            y = 0;
            relative = true;
          };
        "SUPER + CTRL + J" =
          bind {repeating = true;}
          <| dsp "window.resize" {
            x = 0;
            y = 20;
            relative = true;
          };
        "SUPER + CTRL + K" =
          bind {repeating = true;}
          <| dsp "window.resize" {
            x = 0;
            y = -20;
            relative = true;
          };
        "SUPER + CTRL + L" =
          bind {repeating = true;}
          <| dsp "window.resize" {
            x = 20;
            y = 0;
            relative = true;
          };

        "SUPER + mouse:272" = dsp "window.drag" null;
        "SUPER + mouse:273" = dsp "window.resize" null;
      }
      // (range 1 8
        |> foldl' (acc: workspace:
          acc
          // {
            "SUPER + ${workspace}" = dsp "focus" {inherit workspace;};
            "SUPER + SHIFT + ${workspace}" = dsp "window.move" {inherit workspace;};
          }) {})
      // {
        "SUPER + S" = dsp "workspace.toggle_special" "scratchpad";
      };

    workspaces."special:scratchpad" = {
      on_created_empty = ghostty';
      gaps_out = cfg.general.gaps_out * 12;
    };
  };
}
