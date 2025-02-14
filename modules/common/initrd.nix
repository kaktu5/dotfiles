_: {
  boot = {
    initrd.systemd.enable = true;
    consoleLogLevel = 3;
    kernelParams = ["quiet"];
  };
}
