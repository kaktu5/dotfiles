_: {
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    keyboards."default" = {
      extraArgs = ["--nodelay"];
      config = ''
        (defsrc
          caps)
        (defalias
          escctrl (tap-hold 120 120 esc lctrl))
        (deflayer base
          @escctrl)
      '';
    };
  };
}
