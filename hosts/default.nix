{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) nixpkgs nixpkgs-stable;
  inherit (lib) nixosSystem;
  mkSystem = path: type: system:
    nixosSystem (let
      pkgs = import nixpkgs ({inherit system;} // {config.allowUnfree = true;});
      spkgs = import nixpkgs-stable ({inherit system;} // {config.allowUnfree = true;});
    in {
      inherit pkgs;
      specialArgs = {inherit inputs spkgs;};
      modules = [path ../modules/common (../modules + "/${type}")];
    });
in {
  desktop = mkSystem ./desktop "desktop" "x86_64-linux";
  mercury = mkSystem ./mercury "server" "x86_64-linux";
}
