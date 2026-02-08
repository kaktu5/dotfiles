{
  kkts.programs.hyprland.settings = {
    workspace = [
      ["s[false]w[tv1]" "gapsout:0" "gapsin:0"]
      ["s[false]f[1]" "gapsout:0" "gapsin:0"]
    ];

    windowrule = [
      {
        name = "smartgaps-tiled";
        match = {
          float = false;
          workspace = "s[false]w[tv1]";
        };
        border_size = 0;
      }
      {
        name = "smartgaps-fullscreen";
        match = {
          float = false;
          workspace = "s[false]f[1]";
        };
        border_size = 0;
      }
    ];
  };
}
