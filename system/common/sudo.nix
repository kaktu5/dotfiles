{pkgs, ...}: {
  security.sudo = {
    package = pkgs.sudo.override {withInsults = true;};
    extraConfig = "Defaults pwfeedback, lecture=never";
    execWheelOnly = true;
  };
}
