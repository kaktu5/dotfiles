{inputs}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.lib.fixedPoints) fix;
in
  fix (lib:
    nixpkgs.lib
    // {
      kkts = {
        modules = import ./modules.nix {inherit lib;};
        nixos = import ./nixos.nix {inherit lib;};
      };
    })
