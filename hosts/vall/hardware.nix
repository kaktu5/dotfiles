{
  hardware.enableRedistributableFirmware = true;

  boot = {
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

  kkts.hardware.monitors = {
    primaryMonitor = "eDP-1";

    monitors.eDP-1 = {
      resolution = {
        w = 1920;
        h = 1200;
      };
      # scale = 1.20;
      refreshRate = 60;
    };
  };
}
