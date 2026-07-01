{
  boot = {
    initrd.kernelModules = ["ata_piix" "sd_mod" "sr_mod" "uhci_hcd" "virtio_pci" "virtio_scsi"];

    loader.limine.biosDevice = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
  };

  kkts.boot.loader = "limine";
}
