{
  hardware.uinput.enable = true;

  services.kanata = {
    enable = true;

    keyboards.builtin = {
      devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];

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
