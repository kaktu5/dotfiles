{lib, ...}: let
  inherit (lib.lists) concatMap range;

  term = "ghostty +new-window";
in {
  kkts.programs.hyprland.settings = {
    bind =
      [
        ["super" "return" "exec" term]
        ["super" "space" "exec" "rofi -show drun -run-command 'uwsm app -- {cmd}'"]

        ["super" "c" "killactive"]
        ["super" "o" "fullscreen" 1] # maximize
        ["super" "f" "togglefloating"]
        ["super" "f" "centerwindow" 1] # respect monitor reserved area
        ["super shift" "f" "centerwindow" 1] # respect monitor reserved area
        ["super" "r" "togglesplit"]
        ["super" "tab" "cyclenext"]
        ["super shift" "tab" "cyclenext" "prev"]
        ["super shift" "escape" "exec" "uwsm stop"]

        ["super" "h" "movefocus" "l"]
        ["super" "j" "movefocus" "d"]
        ["super" "k" "movefocus" "u"]
        ["super" "l" "movefocus" "r"]

        ["super shift" "h" "movewindow" "l"]
        ["super shift" "j" "movewindow" "d"]
        ["super shift" "k" "movewindow" "u"]
        ["super shift" "l" "movewindow" "r"]
      ]
      ++ (range 1 8
        |> concatMap (n: [
          ["super" n "workspace" n]
          ["super shift" n "movetoworkspace" n]
        ]))
      ++ [
        ["super" "s" "togglespecialworkspace" "term"]
        ["super" "b" "togglespecialworkspace" "btop"]
      ];

    binde = [
      ["super ctrl" "h" "resizeactive" "-20 0"]
      ["super ctrl" "j" "resizeactive" "0 20"]
      ["super ctrl" "k" "resizeactive" "0 -20"]
      ["super ctrl" "l" "resizeactive" "20 0"]
    ];

    bindm = [
      ["super" "mouse:272" "movewindow"] # lmb
      ["super" "mouse:273" "resizewindow"] # rmb
    ];

    workspace = [
      ["special:term" "gapsout:120" "on-created-empty:${term}"]
      ["special:btop" "gapsout:120" "on-created-empty:${term} -e btop"]
    ];
  };
}
