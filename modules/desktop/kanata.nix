_: let
  inherit (builtins) toFile;
in {
  hardware.uinput.enable = true;
  services.kanata = {
    enable = true;
    keyboards."default" = {
      extraArgs = ["--nodelay"];
      configFile = toFile "kanata-config" ''
        (defcfg
          linux-continue-if-no-devs-found yes
          process-unmapped-keys no)
        (defsrc caps)
        (defalias escctrl
          (tap-hold 80 80 esc lctrl))
        (deflayer base @escctrl)
      '';
    };
  };
}
