{
  inputs,
  lib,
  installFonts,
  stdenvNoCC,
}: let
  inherit (inputs) space-mono;
  inherit (inputs._meta.space-mono) lastModified;
  inherit (lib.kkts.versions) unstableVersion;
  inherit (lib.licenses) ofl;
  inherit (lib.platforms) all;
  inherit (stdenvNoCC) mkDerivation;
in
  mkDerivation {
    pname = "space-mono";
    version = unstableVersion lastModified;

    src = "${space-mono}/fonts";

    outputs = ["out" "webfont"];

    nativeBuildInputs = [installFonts];

    meta = {
      description = "Original monospace display typeface family designed by Colophon Foundry for Google Design";
      homepage = "https://github.com/googlefonts/spacemono";
      license = ofl;
      platforms = all;
    };
  }
