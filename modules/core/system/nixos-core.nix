{
  config,
  inputs,
  ...
}: let
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (inputs.nixos-core) nixosModules;
  inherit (inputs.nixos-core.packages.${system}) nixos-core;
in {
  imports = [nixosModules.default];

  system.nixos-core = {
    enable = true;

    package = nixos-core.override {
      withUpdateUsersGroups = false;
      withSetupEtc = false;
      withInitScript = false;
      withStage1 = false;
    };
  };
}
