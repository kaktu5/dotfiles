{sources}: _: prev: let
  inherit (prev.stdenv.hostPlatform) system;

  flake-compat = import sources.flake-compat;
in {
  statix = (flake-compat {src = sources.statix;}).defaultNix.packages.${system}.default;
}
