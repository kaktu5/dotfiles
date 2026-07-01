{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config) fileSystems;
  inherit (config.boot) zfs;
  inherit (lib.attrsets) attrValues;
  inherit (lib.kkts.generators) toNuon;
  inherit (lib.kkts.strings) replaceVars;
  inherit (lib.lists) any;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) makeBinPath;
  inherit (pkgs.writers) writeNuBin;

  zfsAutoSnapshot =
    writeNuBin "zfs-auto-snapshot"
    <| replaceVars ./auto-snapshot.nu {
      path = makeBinPath [zfs.package];

      config = toNuon {} {
        daily = 7;
        weekly = 2;
      };
    };

  hasZfsFilesystrem = fileSystems |> attrValues |> any (fs: fs.fsType == "zfs");

  interval = "weekly";
  randomizedDelaySec = "15m";
in
  mkIf hasZfsFilesystrem {
    services.zfs = {
      autoScrub = {
        enable = true;
        inherit interval randomizedDelaySec;
      };

      trim = {
        enable = true;
        inherit interval randomizedDelaySec;
      };
    };

    systemd = {
      services = {
        zfs-scrub.serviceConfig.Slice = "background.slice";
        zpool-trim.serviceConfig.Slice = "background.slice";

        "zfs-auto-snapshot@" = {
          after = ["zfs-import.target"];
          wants = ["zfs-import.target"];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${getExe zfsAutoSnapshot} %i";
            Slice = "background.slice";
          };
        };
      };

      timers = let
        mkZfsAutoSnapshotTimer = OnCalendar: {
          wantedBy = ["timers.target"];

          timerConfig = {
            inherit OnCalendar;
            Persistent = true;
            RandomizedDelaySec = randomizedDelaySec;
          };
        };
      in {
        "zfs-auto-snapshot@daily" = mkZfsAutoSnapshotTimer "*-*-* 03:00:00";
        "zfs-auto-snapshot@weekly" = mkZfsAutoSnapshotTimer "Sat *-*-* 03:00:00";
      };
    };
  }
