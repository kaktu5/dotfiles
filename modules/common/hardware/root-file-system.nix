{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr str;
  inherit (lib.types.ints) positive;
  cfg = config.kkts.hardware.rootFileSystem;
in {
  imports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModules.default
  ];
  options.kkts.hardware.rootFileSystem = {
    enable = mkEnableOption "disko and impermanence" // {default = true;};
    device = mkOption {type = str;};
    root = mkOption {type = nullOr str;} // {default = null;}; # only needed for LUKS encrypted devices
    swapSize = mkOption {type = nullOr positive;} // {default = null;};
  };
  config = mkIf cfg.enable {
    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist/root" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/home" # tmp
      ];
      files = ["/etc/machine-id"];
    };
  };
}
