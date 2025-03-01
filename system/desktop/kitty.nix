{
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (lib.kkts) mkWrapper;
  inherit (pkgs) writeText;
  inherit (theme) colors fonts;
  kittyConfig = writeText "kitty-config" ''
    font_family ${fonts.monospace.name}
    font_size 10.0
    window_padding_width 4
    default_pointer_shape arrow
    mouse_hide_wait 0.0
    cursor_shape beam
    cursor_shape_unfocused beam
    cursor_blink_interval 0
    cursor_beam_thickness 1.5
    cursor_trail 1
    cursor_trail_decay 0.1 0.1
    cursor_trail_start_threshold 0
    scrollback_lines 4096
    url_style straight
    enable_audio_bell no
    confirm_os_window_close 0

    cursor #${colors.term7}
    cursor_text_color #${colors.term7}

    foreground #${colors.term7}
    background #${colors.termBg}

    color0 #${colors.term0}
    color1 #${colors.term1}
    color2 #${colors.term2}
    color3 #${colors.term3}
    color4 #${colors.term4}
    color5 #${colors.term5}
    color6 #${colors.term6}
    color7 #${colors.term7}

    color8 #${colors.term0}
    color9 #${colors.term1}
    color10 #${colors.term2}
    color11 #${colors.term3}
    color12 #${colors.term4}
    color13 #${colors.term5}
    color14 #${colors.term6}
    color15 #${colors.term7}

    url_color #${colors.purple}
    selection_foreground none
    selection_background #${colors.blue}

    symbol_map U+e000-U+e00a,U+ea60-U+ebeb,U+e0a0-U+e0c8,U+e0ca,U+e0cc-U+e0d7,U+e200-U+e2a9,U+e300-U+e3e3,U+e5fa-U+e6b1,U+e700-U+e7c5,U+ed00-U+efc1,U+f000-U+f2ff,U+f000-U+f2e0,U+f300-U+f372,U+f400-U+f533,U+f0001-U+f1af0 Symbols Nerd Font Mono

  '';
  kitty' = mkWrapper "kitty" [pkgs.kitty] [
    "--add-flags '-1'"
    "--add-flags '-c ${kittyConfig}'"
  ];
in {home.packages = [kitty'];}
