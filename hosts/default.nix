{
  inputs,
  lib,
  self,
  sources,
}: let
  inherit (lib.kkts.nixos) mkSystemsFromAttrs;

  specialArgs = {
    inherit inputs lib sources;
    flake = self;
  };
in
  mkSystemsFromAttrs {inherit specialArgs;} {
    neidon = {
      system = "x86_64-linux";
      roles = ["headless" "server"];
    };
  }
