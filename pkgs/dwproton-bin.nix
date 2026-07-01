{
  inputs,
  lib,
  stdenvNoCC,
  steamDisplayName ? "DW-Proton",
}: let
  inherit (inputs) dwproton-bin;
  inherit (inputs._meta.dwproton-bin) version;
  inherit (lib.licenses) bsd3;
  inherit (lib.sourceTypes) binaryNativeCode;
  inherit (stdenvNoCC) mkDerivation;
in
  mkDerivation (finalAttrs: {
    pname = "dwproton-bin";
    inherit version;

    src = dwproton-bin;

    outputs = ["out" "steamcompattool"];

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      echo '${finalAttrs.pname} should not be installed into environments. Please use programs.steam.extraCompatPackages instead.' > $out

      mkdir $steamcompattool
      ln -s $src/* $steamcompattool
      rm $steamcompattool/compatibilitytool.vdf
      cp $src/compatibilitytool.vdf $steamcompattool

      runHook postInstall
    '';

    preFixup = ''
      substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
        --replace-fail "dwproton-${finalAttrs.version}-x86_64" '${steamDisplayName}'
    '';

    meta = {
      description = "Proton build with the latest Dawn Winery fixes";
      homepage = "https://dawn.wine/dawn-winery/dwproton";
      license = bsd3;
      platforms = ["x86_64-linux"];
      sourceProvenance = [binaryNativeCode];
    };
  })
