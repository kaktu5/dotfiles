{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = ["${modulesPath}/installer/scan/not-detected.nix"];
  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "ehci_pci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "xhci_pci"
    ];
    kernelModules = ["kvm-amd"];
  };
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
