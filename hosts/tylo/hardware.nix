{
  hardware.enableRedistributableFirmware = true;

  boot = {
    kernelParams = ["mem_sleep_default=s2idle"]; # for some fucking reason the firmware defaults to S3

    initrd.kernelModules = [
      "ahci"
      "sr_mod"
      "virtio_blk"
      "virtio_pci"
      "xhci_pci"
    ];
  };

  kkts.hardware = {
    cpu.amd.enable = true;
    gpu.amd.enable = true;

    monitors = {
      primaryMonitor = "HDMI-A-1";

      monitors.HDMI-A-1 = {
        resolution = {
          w = 1920;
          h = 1080;
        };
        refreshRate = 75;
        variableRefreshRate = true;
      };
    };
  };
}
