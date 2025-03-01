{
  bind = [
    "super, q, exec, kitty -1 tmux"
    "super shift, q, exec, kitty -1"
    "super, space, exec, rofi -show drun -run-command 'uwsm app -- {cmd}'"

    ", print, exec, screenshot window"
    "super, print, exec, screenshot screen"
    "super shift, print, exec, screenshot region"

    "super, c, killactive"
    "super, f, fullscreen, 1"
    "super shift, f, togglefloating"
    "super, r, togglesplit"
    "super, tab, cyclenext"
    "super, tab, bringactivetotop"
    "super shift, escape, exit"

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
  ];
  binde = [
    "super ctrl, h, resizeactive, -20 0"
    "super ctrl, j, resizeactive, 0 20"
    "super ctrl, k, resizeactive, 0 -20"
    "super ctrl, l, resizeactive, 20 0"
  ];
  bindm = ["super, mouse:272, movewindow" "super, mouse:273, resizewindow"];
}
