{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
  cfg = config.kkts.hardware;
in {
  imports = [
    (mkIf cfg.amd.cpu.enable (import ./amd/cpu.nix {inherit config;}))
    (mkIf cfg.amd.gpu.enable (import ./amd/gpu.nix {inherit pkgs;}))
    (mkIf cfg.bluetooth.enable (import ./bluetooth.nix {inherit config;}))
    (mkIf cfg.fstrim.enable (import ./filesystems.nix {
      inherit lib pkgs;
      btrfs = cfg.fstrim.btrfs.enable;
      zfs = cfg.fstrim.zfs.enable;
    }))
    ./qemu-guest.nix
  ];
  options.kkts.hardware = {
    amd = {
      cpu.enable = mkOption {type = bool;} // {default = false;};
      gpu.enable = mkOption {type = bool;} // {default = false;};
    };
    bluetooth.enable = mkOption {type = bool;} // {default = false;};
    fstrim = {
      enable = mkOption {type = bool;} // {default = false;};
      btrfs.enable = mkOption {type = bool;} // {default = false;};
      zfs.enable = mkOption {type = bool;} // {default = false;};
    };
  };
  /*
  config.boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = ["dm-snapshot"];
    };
    kernelModules = ["kvm-amd"];
  };
  */
}
