{
  inputs,
  lib,
  clickgen,
  resvg,
  stdenvNoCC,
  themeName ? "BreezeX",
  baseColor ? "#000000",
  outlineColor ? "#ffffff",
  watchColor ? "#000000",
  xcursorSizes ? [16 20 22 24 28 32 40 48 56 64 72 80 88 96],
}: let
  inherit (inputs) breezex-cursor;
  inherit (inputs._meta.breezex-cursor) version;
  inherit (lib.licenses) gpl3;
  inherit (lib.platforms) all;
  inherit (lib.strings) concatMapStringsSep;
  inherit (stdenvNoCC) mkDerivation;

  bitmapDir = "bitmaps/${themeName}";
in
  mkDerivation {
    pname = "breezex-cursor";
    inherit version;

    src = breezex-cursor;

    nativeBuildInputs = [clickgen resvg];

    buildPhase = ''
      runHook preBuild

      mkdir -p ${bitmapDir}
      shopt -s globstar

      for svg in svg/**/*.svg; do
        sed \
          -e 's/#00FF00/${baseColor}/g' \
          -e 's/#0000FF/${outlineColor}/g' \
          -e 's/#FF0000/${watchColor}/g' \
          "$svg" \
          | resvg --resources-dir "$(dirname "$svg")" --width 222 --height 222 \
              - "${bitmapDir}/$(basename "$svg" .svg).png"
      done

      ctgen configs/x.build.toml \
        -s ${concatMapStringsSep " " toString xcursorSizes} \
        -p x11 \
        -d ${bitmapDir} \
        -n ${themeName}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -dm 755 $out/share/icons
      cp -r themes/${themeName} $out/share/icons/

      runHook postInstall
    '';

    meta = {
      description = "Extended KDE cursor";
      homepage = "https://github.com/ful1e5/breezex_cursor";
      license = gpl3;
      platforms = all;
    };
  }
