{
  inputs,
  pkgs,
}: let
  inherit (pkgs) system;
in
  pkgs.runCommandLocal "lockfile-check" {
    src = ./.;
    nativeBuildInputs = [inputs.flint.packages.${system}.default];
  } ''
    find "$src" -type f -name 'flake.lock' \
      | xargs flint --fail-if-multiple-versions --lockfile
    touch "$out"
  ''
