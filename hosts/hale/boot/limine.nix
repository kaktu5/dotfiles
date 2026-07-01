{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  boot = {
    lanzaboote.enable = mkForce false;

    loader.limine = {
      enable = true;

      enableEditor = false;

      efiSupport = false;
      biosDevice = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
    };
  };
}
