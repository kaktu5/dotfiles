# TODO: support aarch64
{pkgs, ...}: let
  inherit (pkgs) memtest86-efi;
in {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 1;
    limine = {
      enable = true;
      secureBoot.enable = true;
      enableEditor = false;
      maxGenerations = 24;
      style.wallpapers = [];
      extraEntries = ''
        /Memtest86
          protocol: efi
          path: boot():/limine/efi/memtest86/BOOTX64.efi
          comment: Memtest86 ${memtest86-efi.version}
      '';
      additionalFiles."efi/memtest86/BOOTX64.efi" = memtest86-efi + /BOOTX64.efi;
    };
  };
}
