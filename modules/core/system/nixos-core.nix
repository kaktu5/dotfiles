{
  config,
  inputs',
  lib,
  ...
}: let
  inherit (inputs'.nixos-core) nixosModules;
  inherit (inputs'.nixos-core.packages) nixos-core;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (lib.options) mkOption;
  inherit (lib.types) str;

  cfg = config.kkts.persistence;
in {
  imports = [
    nixosModules.default

    (mkAliasOptionModule ["persistence"] ["system" "nixos-core" "persistence" "stores" cfg.store])
  ];

  options.kkts.persistence.store = mkOption {type = str;};

  config = {
    system.nixos-core = {
      enable = true;

      package = nixos-core.override {
        withInitScript = false;
        withStage1 = false;
      };

      # TODO:
      # components.bootloaderInstaller.enable = true;

      persistence.enable = true;
    };

    persistence.commonMountOptions = ["x-gdu.hide" "x-gvfs-hide"];
  };
}
