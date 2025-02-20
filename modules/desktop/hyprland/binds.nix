{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) username;
  inherit (config.stylix.base16Scheme) base02 base05;
  inherit (lib) getExe;
  inherit (pkgs) writeShellScriptBin;
  screenshot-window = let
    cut = "${pkgs.coreutils}/bin/cut";
    grim = getExe pkgs.grim;
    hyprctl = "${pkgs.hyprland}/bin/hyprctl";
    jq = getExe pkgs.jq;
    tr = "${pkgs.coreutils}/bin/tr";
    wlCopy = "${pkgs.wl-clipboard}/bin/wl-copy";
  in
    writeShellScriptBin "screenshot-window" ''
      window=$(${hyprctl} activewindow -j)

      gaps=$(${hyprctl} getoption -j general:gaps_out \
        | ${jq} -r ".custom" \
        | ${cut} -d " " -f 1)

      pos=$(echo $window \
        | ${jq} -r ".at | @sh" \
        | ${tr} -d "'")
      IFS=" " read -r pos_x pos_y << EOF
        $pos
      EOF

      size=$(echo $window \
        | ${jq} -r ".size | @sh" \
        | ${tr} -d "'")
      IFS=" " read -r size_x size_y << EOF
        $size
      EOF

      pos_x=$((pos_x - 2 * gaps))
      pos_y=$((pos_y - 2 * gaps))
      size_x=$((size_x + 4 * gaps))
      size_y=$((size_y + 4 * gaps))

      ${grim} -g "''${pos_x},''${pos_y} ''${size_x}x''${size_y}" - \
        | ${wlCopy} -t image/png
    '';
  screenshot-select = let
    grim = getExe pkgs.grim;
    sed = getExe pkgs.gnused;
    slurp = getExe pkgs.slurp;
    wlCopy = "${pkgs.wl-clipboard}/bin/wl-copy";
  in
    writeShellScriptBin "screenshot-select" ''
      selection=$(${slurp} -b \#${base02}cc -c \#${base05}ff \
        | ${sed} "s/[x, ]/;/g")

      IFS=";" read -r pos_x pos_y size_x size_y << EOF
        $selection
      EOF

      pos_x=$((pos_x + 1))
      pos_y=$((pos_y + 1))
      size_x=$((size_x - 2))
      size_y=$((size_y - 2))

      ${grim} -g "''${pos_x},''${pos_y} ''${size_x}x''${size_y}" - \
        | ${wlCopy} -t image/png
    '';
  kitty = "${getExe pkgs.kitty} -1";
  btop = getExe pkgs.btop;
  rofi = getExe pkgs.rofi-wayland;
  grim = getExe pkgs.grim;
in {
  home-manager.users.${username}.wayland.windowManager.hyprland.settings = {
    input = {
      sensitivity = -0.75;
      kb_layout = "pl";
    };
    workspace = [
      "special:term, gapsout:120, on-created-empty:${kitty} tmux"
      "special:btop, gapsout:120, on-created-empty:${kitty} ${btop}"
    ];
    bind = [
      "super, q, exec, ${kitty} tmux"
      "super shift, q, exec, ${kitty}"
      "super, space, exec, ${rofi} -show drun"

      ", print, exec, ${getExe screenshot-window}"
      "super, print, exec, ${grim} - | wl-copy"
      "super shift, print, exec, ${getExe screenshot-select}"

      "super, c, killactive"
      "super, o, fullscreen, 1"
      "super, u, togglefloating"
      "super, i, togglesplit"
      "super, tab, cyclenext"
      "super, tab, bringactivetotop"
      "super shift, m, exit"

      "super, h, movefocus, l"
      "super, j, movefocus, d"
      "super, k, movefocus, u"
      "super, l, movefocus, r"

      "super shift, h, movewindow, l"
      "super shift, j, movewindow, d"
      "super shift, k, movewindow, u"
      "super shift, l, movewindow, r"

      "super, 1, workspace, 1"
      "super, 2, workspace, 2"
      "super, 3, workspace, 3"
      "super, 4, workspace, 4"
      "super, 5, workspace, 5"
      "super, 6, workspace, 6"
      "super, 7, workspace, 7"
      "super, 8, workspace, 8"

      "super shift, 1, movetoworkspace, 1"
      "super shift, 2, movetoworkspace, 2"
      "super shift, 3, movetoworkspace, 3"
      "super shift, 4, movetoworkspace, 4"
      "super shift, 5, movetoworkspace, 5"
      "super shift, 6, movetoworkspace, 6"
      "super shift, 7, movetoworkspace, 7"
      "super shift, 8, movetoworkspace, 8"

      "super, s, togglespecialworkspace, term"
      "super, b, togglespecialworkspace, btop"
    ];
    binde = [
      "super ctrl, h, resizeactive, -20 0"
      "super ctrl, j, resizeactive, 0 20"
      "super ctrl, k, resizeactive, 0 -20"
      "super ctrl, l, resizeactive, 20 0"
    ];
    bindm = ["super, mouse:272, movewindow" "super, mouse:273, resizewindow"];
  };
}
