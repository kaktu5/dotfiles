{
  security = {
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults !lecture
        Defaults pwfeedback
      '';
    };
    sudo.enable = false;
    shadow.enable = false;
  };
}
