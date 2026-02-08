{
  outputs = {self, ...} @ inputs: let
    lib = import ./lib {inherit inputs;};

    inherit (lib.attrsets) mapAttrs recursiveUpdate;
    inherit (lib.lists) foldl';

    mapSystems = systems: f: (foldl' (acc: system: (f system
      |> mapAttrs (_: value: {${system} = value;})
      |> recursiveUpdate acc)) {}
    systems);

    sources = import ./npins/default.nix;
  in
    mapSystems (import inputs.systems) (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};
    })
    // {
      inherit lib;

      nixosConfigurations = import ./hosts {inherit inputs lib self sources;};
    };

  inputs = {
    systems = {
      url = "path:internal/systems.nix";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "";
        nixpkgs.follows = "nixpkgs";
        smfh.follows = "";
      };
    };
    preservation.url = "github:nix-community/preservation";
    tuigreet = {
      url = "github:notashelf/tuigreet";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
