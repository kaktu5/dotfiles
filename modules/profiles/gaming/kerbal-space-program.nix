{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.users.users.${userName}) home;
  inherit (lib.attrsets) attrValues;
  inherit (lib.generators) toJSON;
  inherit (lib.lists) elem singleton;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (pkgs) buildFHSEnv ckan makeDesktopItem;

  kspDir = "games/kerbal-space-program";

  generator = toJSON {};
  type = "copy";
  permissions = "644";

  wrapper = buildFHSEnv {
    name = "kerbal-space-program-env";
    targetPkgs = _: (attrValues {
      inherit
        (pkgs)
        SDL2
        alsa-lib
        corefonts
        glibc
        libGL
        libGLU
        libpulseaudio
        libx11
        libxcursor
        libxext
        libxi
        libxinerama
        libxrandr
        libxxf86vm
        udev
        zlib
        ;
      inherit (pkgs.stdenv.cc.cc) lib;
    });
    profile = "export SDL_VIDEODRIVER=x11";
    runScript = "${home}/${kspDir}/game/KSP.x86_64 -single-instance";
  };

  desktopEntry = makeDesktopItem {
    name = "kerbal-space-program-desktop-item";
    desktopName = "Kerbal Space Program";
    exec = getExe wrapper;
    icon = "${home}/${kspDir}/support/icon.png";
    categories = ["Game" "Simulation"];
  };
in
  mkIf (gaming.enable && elem "kerbal-space-program" gaming.games) {
    persistence.users.${userName} = {
      directories = [".local/share/CKAN/downloads" ".local/share/CKAN/repos"];
      files = [".local/share/CKAN/builds-ksp.json"];
    };

    users.users.${userName}.packages = [ckan desktopEntry];

    hjem.users.${userName} = {
      xdg.data.files."CKAN/config.json" = {
        inherit generator type permissions;
        value = {
          AutoStartInstance = "ksp";
          GameInstances = singleton {
            Name = "ksp";
            Path = "${home}/${kspDir}/game";
            Game = "KSP";
          };
        };
      };

      files."${kspDir}/game/CKAN/GUIConfig.json" = {
        inherit generator type permissions;
        value = {
          CommandLines = [(getExe wrapper)];
          HideV = true;
          RefreshOnStartup = false;
          DefaultSearches = ["is:installed"];
          SortColumns = ["ModName"];
          MultiSortDescending = [false];
        };
      };
    };
  }
