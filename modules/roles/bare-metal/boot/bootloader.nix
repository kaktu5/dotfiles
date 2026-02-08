{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lists) optional;
  inherit (pkgs) memtest86-efi sbctl;

  optional' = optional config.boot.loader.limine.secureBoot.enable;
in {
  preservation.preserveAt."/persist".directories = optional' {
    directory = "/var/lib/sbctl";
    mode = "u=rwx,g=,o=";
  };

  environment.systemPackages = optional' sbctl;

  boot.loader = {
    timeout = 1;

    efi.canTouchEfiVariables = true;

    limine = {
      enable = true;
      enableEditor = false;

      secureBoot.enable = true;
      panicOnChecksumMismatch = true;

      resolution = "max";
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
