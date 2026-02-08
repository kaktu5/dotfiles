{
  kkts.programs.hyprland = {
    curves.easeout = {
      type = "bezier";
      points = [[0.33 1] [0.68 1]];
    };

    animations = {
      windows = {
        enabled = true;
        speed = 2;
        bezier = "easeout";
        style = "popin";
      };

      layers = {
        enabled = true;
        speed = 2;
        bezier = "default";
      };

      fade = {
        enabled = true;
        speed = 2;
        bezier = "default";
      };

      border = {
        enabled = true;
        speed = 3;
        bezier = "default";
      };

      workspaces = {
        enabled = true;
        speed = 3;
        bezier = "easeout";
        style = "slidevert";
      };

      monitorAdded.enabled = false;
    };
  };
}
