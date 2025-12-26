{
  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;

    inherit (lib.attrsets) mapAttrs recursiveUpdate;
    inherit (lib.lists) foldl';

    mapSystems = systems: f: (foldl' (acc: system: (f system
      |> mapAttrs (_: value: {${system} = value;})
      |> recursiveUpdate acc)) {}
    systems);

    sources = import ./npins/default.nix;
  in
    mapSystems (import inputs.systems) (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system}.extend (
        import ./internal/overlay.nix {inherit sources;}
      );
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};
    });

  inputs = {
    systems = {
      url = "path:internal/systems.nix";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
}
