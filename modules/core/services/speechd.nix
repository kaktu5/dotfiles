{lib, ...}: let
  inherit (lib.modules) mkForce;
in {
  services.speechd.enable = mkForce false;
}
