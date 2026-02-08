{
  inputs,
  lib,
  self,
}: let
  inherit (lib.kkts.nixos) mkSystemsFromAttrs;

  specialArgs = {
    inherit inputs lib;
    flake = self;
    inherit self; # vaultix
  };
in
  mkSystemsFromAttrs {inherit specialArgs;} {
    neidon = {
      system = "x86_64-linux";
      roles = ["headless" "server"];
    };
  }
