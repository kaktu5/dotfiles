{
  outputs = {self}: let
    systems = ["aarch64-linux" "x86_64-linux"];

    inputs = import ./.tack;

    lib = import ./lib {inherit inputs self;};
    inherit (lib.attrsets) mapAttrs zipAttrsWith;
    inherit (lib.lists) foldl';

    mapSystems = systems: f:
      systems
      |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
      |> zipAttrsWith (_: foldl' (a: b: a // b) {});
  in
    mapSystems systems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./flake/devshell.nix {inherit inputs lib pkgs self system;};

      formatter = import ./flake/formatter.nix {inherit lib pkgs;};

      packages = import ./flake/packages {inherit pkgs;};
    })
    // {
      inherit lib;

      nixosConfigurations = import ./hosts {inherit lib;};

      vaultix = import ./flake/vaultix.nix {inherit inputs self systems;};
    };
}
