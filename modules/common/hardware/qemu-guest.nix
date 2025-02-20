{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  cfg = config.kkts.hardware.qemuGuest;
in {
  options.kkts.hardware.qemuGuest.enable = mkEnableOption "qemu guest support";
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
