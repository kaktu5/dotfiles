{inputs', ...}: let
  inherit (inputs'.nixos-core) nixosModules;
  inherit (inputs'.nixos-core.packages) nixos-core;
in {
  imports = [nixosModules.default];

  system.nixos-core = {
    enable = true;

    package = nixos-core.override {
      withInitScript = false;
      withStage1 = false;
    };
  };
}
