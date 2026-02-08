{
  outputs = {self, ...} @ inputs: let
    lib = import ./lib {inherit inputs;};

    inherit (lib.attrsets) mapAttrs recursiveUpdate;
    inherit (lib.lists) foldl';

    systems = import inputs.systems;
    mapSystems = systems: f: (foldl' (acc: system: (f system
      |> mapAttrs (_: value: {${system} = value;})
      |> recursiveUpdate acc)) {}
    systems);

    sources = import ./npins/default.nix;
  in
    mapSystems systems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs self system;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};
    })
    // {
      inherit lib;

      nixosConfigurations = import ./hosts {inherit inputs lib self sources;};

      vaultix = import ./internal/vaultix.nix {inherit inputs self systems;};
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
    vaultix = {
      url = "github:milieuim/vaultix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.inputs = {
          gitignore.inputs.nixpkgs.follows = "nixpkgs";
          nixpkgs.follows = "nixpkgs";
        };
        rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
