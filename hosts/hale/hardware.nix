{
  boot = {
    # prevent udev from loading sr_mod for unused cloud-init drives
    blacklistedKernelModules = ["sr_mod"];

    initrd.kernelModules = ["sd_mod" "virtio_pci" "virtio_scsi"];

    loader.limine.biosDevice = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
  };

  kkts.boot.loader = "limine";
}
