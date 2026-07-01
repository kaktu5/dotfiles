{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  environment = {
    corePackages = mkForce [];
    defaultPackages = mkForce [];
  };
}
