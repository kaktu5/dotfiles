{
  boot.loader = {
    timeout = 0;

    efi.canTouchEfiVariables = true;

    systemd-boot = {
      enable = true;

      bootCounting = {
        enable = true;
        tries = 2;
      };

      configurationLimit = 8;

      consoleMode = "max";

      editor = false;
    };
  };
}
