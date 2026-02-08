{inputs, ...}: let
  inherit (inputs) vaultix;
in {
  imports = [vaultix.nixosModules.default];
}
