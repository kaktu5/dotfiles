{
  hardware.enableRedistributableFirmware = true;

  boot = {
    lanzaboote.measuredBoot.pcrs = [0 1 2 3 7];

    kernelParams = ["acpi_backlight=native"];

    initrd.kernelModules = [
      "kvm-amd"
      "nvme"
      "rtw89_8852ae"
      "sd_mod"
      "usb_storage"
      "xhci_pci"
      "xhci_pci_renesas"
    ];
  };

  kkts.hardware = {
    cpu.amd.enable = true;
    gpu.amd.enable = true;

    monitors = {
      primaryMonitor = "eDP-1";

      monitors.eDP-1 = {
        resolution = {
          w = 1920;
          h = 1200;
        };
        refreshRate = 60;
        variableRefreshRate = true;
      };
    };
  };
}
