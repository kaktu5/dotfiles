{
  inputs,
  self,
}: let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.lib.fixedPoints) fix;
in
  fix (lib:
    nixpkgs.lib
    // {
      kkts = {
        dag = import ./dag.nix {inherit lib;};
        formats = import ./formats.nix {inherit lib;};
        hyprland = import ./hyprland.nix {inherit lib;};
        modules = import ./modules.nix {inherit lib;};
        nixos = import ./nixos.nix {inherit inputs lib self;};
        paths = import ./paths.nix {inherit lib;};
        systemd = import ./systemd.nix {inherit lib;};
      };
    })
