{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-stable;
  inherit (lib) nixosSystem;
  mkSystem = name: type: system:
    nixosSystem (let
      pkgs = import nixpkgs ({inherit system;} // {config.allowUnfree = true;});
      spkgs = import nixpkgs-stable ({inherit system;} // {config.allowUnfree = true;});
    in {
      inherit pkgs;
      specialArgs = {
        inherit inputs spkgs;
        flake = self;
        theme = import ../theme.nix;
      };
      modules = [
        {networking.hostName = name;}
        {nixpkgs.hostPlatform = system;}
        ./${name}
        ../modules/common
        ../modules/${type}
        ../system/common
        ../system/${type}
      ];
    });
in {
  desktop = mkSystem "desktop" "desktop" "x86_64-linux";
  mercury = mkSystem "mercury" "server" "x86_64-linux";
}
