{
  outputs = inputs: let
    lib = import ./lib {inherit (inputs) nixpkgs;};
  in {
    nixosConfigurations = import ./hosts {inherit inputs lib;};
    devShells = lib.kkts.forEachSystem (system: {
      default = import ./shell.nix {
        inherit lib;
        pkgs = import inputs.nixpkgs {inherit system;};
      };
    });
    formatter = lib.kkts.forEachSystem (
      system: (import inputs.nixpkgs {inherit system;}).alejandra
    );
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    aagl = {
      url = "github:ezkea/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    minimal-tmux-status = {
      url = "github:niksingh710/minimal-tmux-status";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nvfdots = {
      url = "github:kaktu5/nvfdots";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yaf = {
      url = "github:kaktu5/yaf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
