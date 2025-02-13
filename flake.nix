{
  outputs = {self, ...} @ inputs: let
    lib = import ./lib {inherit (inputs.nixpkgs) lib;};
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      flake.nixosConfigurations = import ./hosts {inherit inputs lib;};
      systems = ["x86_64-linux" "aarch64-linux"];
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        treefmt = import ./flake/treefmt.nix {inherit inputs pkgs;};
        # flint = import ./flake/flint.nix {inherit inputs pkgs;};
      in {
        packages = {
          default = self.packages.${system}.installer;
          installer = inputs.nixos-generators.nixosGenerate {
            format = "install-iso";
            inherit system;
            specialArgs.nixpkgs = inputs.nixpkgs-stable;
            modules = [./flake/installer.nix];
          };
        };
        formatter = treefmt.wrapper;
        checks = {
          formatting = treefmt.check self;
          # lockfile = flint;
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # my flakes
    colorscheme.url = "github:kaktu5/colorscheme";
    nvf-config = {
      url = "github:kaktu5/nvf-config";
      inputs = {
        flake-utils.follows = "flake-utils";
        flint.follows = "flint";
        nixpkgs.follows = "nixpkgs";
        nvf.follows = "nvf";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    # other inputs
    aagl = {
      url = "github:ezkea/aagl-gtk-on-nix";
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    flint = {
      url = "github:notashelf/flint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "git-hooks";
        systems.follows = "systems";
      };
    };
    impermanence.url = "github:nix-community/impermanence";
    minimal-tmux-status = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        git-hooks.follows = "git-hooks";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # dependencies
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        flake-parts.follows = "flake-parts";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };
    systems.url = "github:nix-systems/default";
  };
}
