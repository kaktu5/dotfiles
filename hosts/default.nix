{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-stable;
  inherit (lib) nixosSystem optionalAttrs;
  inherit (lib.kkts) forEachSystem;
  mkSystem = path: type:
    nixosSystem {
      pkgs = forEachSystem (system: (import nixpkgs {inherit system;}));
      specialArgs =
        {inherit inputs;}
        // optionalAttrs (type == "desktop") {
          spkgs = forEachSystem (
            system: (import nixpkgs-stable {inherit system;})
          );
        };
      modules = [path ../modules/common (../modules + type)];
    };
in {
  desktop = mkSystem ./desktop "desktop";
}
