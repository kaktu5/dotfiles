{
  inputs,
  pkgs,
}: let
  inherit (pkgs) runCommandLocal system;
  flint = inputs.flint.packages.${system}.default;
in
  runCommandLocal "lockfile-check" {
    src = ./.;
    nativeBuildInputs = [flint];
  } ''
    find "$src" -type f -name 'flake.lock' \
      | xargs flint --fail-if-multiple-versions --lockfile
    touch "$out"
  ''
