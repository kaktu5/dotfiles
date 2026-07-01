{
  inputs',
  lib,
  ...
}: let
  inherit (inputs'.nixos-core) nixosModules;
  inherit (inputs'.nixos-core.packages) nixos-core;
  inherit (lib.modules) mkAliasOptionModule;
in {
  imports = [
    nixosModules.default

    (mkAliasOptionModule ["persistence"] ["system" "nixos-core" "persistence" "stores" "/persist"])
  ];

  system.nixos-core = {
    enable = true;

    package = nixos-core.override {
      withInitScript = false;
      withStage1 = false;
    };

    persistence.enable = true;
  };

  persistence = {
    commonMountOptions = ["x-gdu.hide" "x-gvfs-hide"];

    directories = ["/var/log"];
  };
}
