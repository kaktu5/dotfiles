{
  outputs = {
    self,
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    lib = import ./lib {inherit inputs self;};

    inherit (lib.attrsets) mapAttrs zipAttrsWith;
    inherit (lib.lists) foldl';

    mapSystems = systems: f:
      systems
      |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
      |> zipAttrsWith (_: foldl' (a: b: a // b) {});
  in
    mapSystems (import systems) (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./internal/devshell.nix {inherit lib pkgs self system;};

      formatter = import ./internal/formatter.nix {inherit lib pkgs;};
    })
    // {
      inherit lib;

      nixosConfigurations = import ./hosts {inherit lib;};

      vaultix = import ./internal/vaultix.nix {inherit inputs self;};
    };

  inputs = {
    systems = {
      url = "github:nix-systems/default-linux";
      flake = false;
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixexprs = {
      url = "github:kaktu5/nixexprs";
      inputs.systems.follows = "systems";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs = {
        nix-darwin.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        spectrum.follows = "";
      };
    };
    preservation.url = "github:nix-community/preservation";
    stash = {
      url = "github:notashelf/stash";
      inputs = {
        crane.follows = "crane";
        nixpkgs.follows = "nixpkgs";
      };
    };
    tuigreet = {
      url = "github:notashelf/tuigreet";
      inputs = {
        crane.follows = "crane";
        nixpkgs.follows = "nixpkgs";
      };
    };
    vaultix = {
      url = "github:milieuim/vaultix";
      inputs = {
        crane.follows = "crane";
        flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
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

    # not used directly, pinned only to deduplicate transitive deps
    crane.url = "github:ipetkov/crane";
  };
}
