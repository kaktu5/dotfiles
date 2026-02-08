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

    shadow.enable = false;
    sudo.enable = false;
  };
}
