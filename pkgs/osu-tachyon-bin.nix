{
  inputs,
  lib,
  appimageTools,
  buildFHSEnv,
}: let
  inherit (appimageTools) appimage-exec extract;
  inherit (inputs) osu-tachyon-bin;
  inherit (inputs._meta.osu-tachyon-bin) tag;
  inherit (lib.attrsets) attrValues;
  inherit (lib.licenses) cc-by-nc-40 mit unfreeRedistributable;
  inherit (lib.sourceTypes) binaryNativeCode;
  inherit (lib.strings) removeSuffix;

  pname = "osu-tachyon-bin";
  version = removeSuffix "-tachyon" tag;

  contents = extract {
    inherit pname version;
    src = osu-tachyon-bin;
  };
in
  buildFHSEnv {
    inherit pname version;

    targetPkgs = pkgs: (attrValues {
      inherit appimage-exec;
      inherit
        (pkgs)
        alsa-lib
        icu
        libglvnd
        libx11
        libxext
        libxfixes
        libxi
        libxkbcommon
        libxrandr
        libxscrnsaver
        openssl
        udev
        vulkan-loader
        wayland
        xdg-utils
        ;
    });

    runScript = "appimage-exec.sh -w ${contents} --";

    profile = ''
      export OSU_EXTERNAL_UPDATE_PROVIDER=1
      export OSU_EXTERNAL_UPDATE_STREAM=tachyon
      export vblank_mode=''${vblank_mode:-0}
    '';

    extraInstallCommands = ''
      mv $out/bin/${pname} $out/bin/osu!

      install -Dm444 ${contents}/osu!.desktop -t $out/share/applications
      install -Dm444 ${contents}/osu.png $out/share/icons/hicolor/256x256/apps/osu.png
    '';

    meta = {
      description = "Rhythm is just a *click* away";
      homepage = "https://osu.ppy.sh";
      license = [cc-by-nc-40 mit unfreeRedistributable];
      sourceProvenance = [binaryNativeCode];
      platforms = ["x86_64-linux"];
      mainProgram = "osu!";
    };
  }
