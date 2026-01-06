{inputs}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.lib.fixedPoints) fix;
in
  fix (lib:
    nixpkgs.lib
    // {
      kkts = {
        colors = import ./colors.nix {inherit lib;};
        formats = import ./formats.nix {inherit lib;};
        modules = import ./modules.nix {inherit lib;};
        nixos = import ./nixos.nix {inherit lib;};
      };
    })
