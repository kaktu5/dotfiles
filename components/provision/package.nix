{
  lib,
  rustPlatform,
}: let
  inherit (lib.fileset) toSource unions;
  inherit (lib.trivial) importTOML;
  inherit (rustPlatform) buildRustPackage;

  inherit (importTOML ./Cargo.toml) package;
in
  buildRustPackage (finalAttrs: {
    pname = package.name;
    inherit (package) version;

    src = toSource {
      root = ./.;
      fileset = unions [./Cargo.lock ./Cargo.toml ./src];
    };
    cargoLock.lockFile = finalAttrs.src + /Cargo.lock;

    meta.mainProgram = package.name;
  })
