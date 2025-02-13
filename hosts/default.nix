{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-stable;
  inherit (lib) nixosSystem optionalAttrs;
  mkSystem = path: type: system:
    nixosSystem {
      pkgs = import nixpkgs ({inherit system;} // {config.allowUnfree = true;});
      specialArgs =
        {inherit inputs;}
        // optionalAttrs (type == "desktop") {
          spkgs = import nixpkgs-stable ({inherit system;} // {config.allowUnfree = true;});
        };
      modules = [path ../modules/common (../modules + "/${type}")];
    };
in {
  desktop = mkSystem ./desktop "desktop" "x86_64-linux";
  # mercury = mkSystem ./mercury "server" "x86_64-linux";
}
