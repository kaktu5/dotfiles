{
  hardware.uinput.enable = true;

  services.kanata = {
    enable = true;

    keyboards.internal = {
      devices = ["/dev/input/by-id/usb-Evision_RGB_Keyboard-event-kbd"];

      extraArgs = ["--nodelay"];

      extraDefCfg = "process-unmapped-keys yes";
      config = ''
        (defsrc caps)

        (defvar
          t 150
          alpha (a b c d e f g h i j k l m n o p q r s t u v w x y z))

        (defalias escctrl (tap-hold-release-keys $t $t esc lctrl $alpha))

        (deflayer default @escctrl)
      '';
    };
  };
}
