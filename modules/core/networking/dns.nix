{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  # quad9
  networking.nameservers = mkDefault ["9.9.9.9" "149.112.112.112"];
}
