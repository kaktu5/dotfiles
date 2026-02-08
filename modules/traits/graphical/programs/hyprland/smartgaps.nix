{
  kkts.programs.hyprland = {
    windowRules = {
      smartgaps-tiled = {
        match = {
          float = false;
          workspace = "s[false]w[tv1]";
        };
        border_size = 0;
      };
      smartgaps-fullscreen = {
        match = {
          float = false;
          workspace = "s[false]f[1]";
        };
        border_size = 0;
      };
    };

    workspaces = {
      "s[false]w[tv1]" = {
        gaps_out = 0;
        gaps_in = 0;
      };
      "s[false]f[1]" = {
        gaps_out = 0;
        gaps_in = 0;
      };
    };
  };
}
