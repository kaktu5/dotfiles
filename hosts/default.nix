{lib}: let
  inherit (lib.kkts.nixos) mkHosts;
in
  mkHosts (_: {
    # gigabyte b550 gaming x v2, ryzen 7 5700g, 32gb
    laythe = {
      arch = "x86_64";
      traits = ["bare-metal" "graphical" "workstation"];
    };

    # lenovo m715q, ryzen 3 pro 2200ge, 16gb
    neidon = {
      arch = "x86_64";
      traits = ["bare-metal" "headless" "server"];
    };

    # lenovo thinkpad x13 gen 2, ryzen 5 pro 5650u, 16gb
    vall = {
      arch = "x86_64";
      traits = ["bare-metal" "graphical" "laptop" "workstation"];
    };
  })
