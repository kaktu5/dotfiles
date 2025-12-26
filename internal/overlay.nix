{sources}: _: prev: let
  inherit (prev) callPackage;
  inherit (prev.stdenv.hostPlatform) system;

  flake-compat = import sources.flake-compat;
in {
  npins = callPackage (sources.npins + /npins.nix) {};
  statix = (flake-compat {src = sources.statix;}).defaultNix.packages.${system}.default;
}
