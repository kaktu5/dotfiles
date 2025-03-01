{
  outputs = {self, ...} @ inputs: let
    inherit (inputs) nixos-generators nixpkgs;
    forEachSystem = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    lib = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./lib/default.nix ({inherit (nixpkgs) lib;} // {inherit pkgs;}));
    treefmt = forEachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      import ./flake/treefmt.nix {inherit inputs pkgs;});
  in {
    nixosConfigurations = import ./hosts {inherit inputs lib self;};
    packages = forEachSystem (system: {
      installer = nixos-generators.nixosGenerate {
        format = "install-iso";
        inherit system;
        specialArgs.pkgs = nixpkgs.legacyPackages.${system};
        modules = [./flake/installer.nix];
      };
    });
    formatter = forEachSystem (system: treefmt.${system}.wrapper);
    checks = forEachSystem (system: {formatting = treefmt.${system}.check self;});
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # my flakes
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

    ###
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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ###

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
    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
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
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # non flakes
    dm-mono = {
      url = "github:googlefonts/dm-mono";
      flake = false;
    };
    zsh-auto-notify = {
      url = "github:michaelaquilina/zsh-auto-notify";
      flake = false;
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
