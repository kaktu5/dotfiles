{inputs, ...}: let
  inherit (inputs.vaultix) nixosModules;
in {
  imports = [nixosModules.default];
}
