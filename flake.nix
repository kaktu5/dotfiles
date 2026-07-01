{
  outputs = {self}: let
    inputs = import ./.tack;

    lib = import ./lib {inherit inputs self;};
    inherit (lib.kkts.flake) mapSystems selectSystem;
  in
    mapSystems ["aarch64-linux" "x86_64-linux"] (system: let
      inputs' = inputs |> selectSystem system ["legacyPackages" "packages"];
      pkgs = inputs'.nixpkgs.legacyPackages;
    in {
      devShells.default = import ./flake/devshell.nix {inherit inputs' lib pkgs;};

      formatter = import ./flake/formatter.nix {inherit lib pkgs;};

      packages = import ./flake/packages {inherit pkgs;};
    })
    // {
      inherit lib;

      nixosConfigurations = import ./hosts {inherit lib;};
    };
}
