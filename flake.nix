{
  outputs = {self, ...} @ inputs: let
    lib = import ./lib {inherit inputs;};

    inherit (lib.attrsets) mapAttrs zipAttrsWith;
    inherit (lib.lists) foldl';
    inherit (lib.trivial) mergeAttrs;

    systems = import inputs.systems;
    mapSystems = systems: f:
      systems
      |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
      |> zipAttrsWith (_: foldl' mergeAttrs {});
  in
    mapSystems systems (system: let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs self system;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};
    })
    // {
      inherit lib;

      nixosConfigurations = import ./hosts {inherit inputs lib self;};

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

    dnscrypt-settings = {
      url = "github:quad9dns/dnscrypt-settings";
      flake = false;
    };
    oisd = {
      url = "github:sjhgvr/oisd";
      flake = false;
    };
  };
}
