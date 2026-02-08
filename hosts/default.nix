{lib}: let
  inherit (lib.kkts.nixos) mkHosts;
in
  mkHosts (self: {
    # lenovo m715q, ryzen 3 pro 2200ge, 16gb
    neidon = {
      arch = "x86_64";
      roles = ["bare-metal" "headless" "server"];
      microvms = {inherit (self) nissee thatmo;};
    };
    nissee = {
      inherit (self.neidon) arch;
      roles = ["microvm"];
    };
    thatmo = {
      inherit (self.neidon) arch;
      roles = ["microvm"];
    };
  })
