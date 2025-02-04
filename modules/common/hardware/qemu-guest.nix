{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
  cfg = config.kkts.hardware.qemuGuest;
in {
  options.kkts.hardware.qemuGuest.enable =
    mkOption {type = bool;} // {default = false;};
  config.boot = mkIf cfg.enable {
    initrd = {
      availableKernelModules = [
        "9p"
        "9pnet_virtio"
        "virtio_blk"
        "virtio_mmio"
        "virtio_net"
        "virtio_pci"
        "virtio_scsi"
      ];
      kernelModules = [
        "virtio_balloon"
        "virtio_console"
        "virtio_gpu"
        "virtio_rng"
      ];
    };
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
