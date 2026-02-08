{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.kernelConfig) isEnabled;
  inherit (lib.kkts.systemd) escapePath;
  inherit (lib.lists) optional;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) literalExpression mkEnableOption mkOption;
  inherit (lib.strings) escapeShellArg optionalString;
  inherit (lib.types) nullOr path str;
  inherit (lib.types.ints) positive;
  inherit (pkgs) cryptsetup util-linux;

  cfg = config.kkts.zramSwap;
  hasWriteback = cfg.writeback.device != null;
in {
  options.kkts.zramSwap = {
    enable = mkEnableOption "compressed in-memory swap by the zram kernel module";

    algorithm = mkOption {
      type = str;
      default = "zstd";
      description = "Compression algorithm.";
      example = "lz4";
    };

    size = mkOption {
      type = positive;
      description = "Size of the zram swap in bytes.";
      example = literalExpression "8 * 1024 * 1024 * 1024";
    };

    writeback = {
      device = mkOption {
        type = nullOr path;
        default = null;
        description = "Block device to write incompressible pages back to. Set to null to disable writeback.";
        example = "/dev/disk/by-partuuid/d9eb2e78-4ac3-4d08-9b65-07c05a119d04";
      };

      encryption = {
        cipher = mkOption {
          type = str;
          default = "aes-xts-plain64";
          description = "Cipher used to encrypt the writeback device.";
          example = "xchacha12,aes-adiantum-plain64";
        };

        sectorSize = mkOption {
          type = positive;
          default = 4096;
          description = "Sector size in bytes of the encrypted writeback device.";
          example = 512;
        };

        keySize = mkOption {
          type = positive;
          default = 512;
          description = "Encryption key size in bits.";
          example = 256;
        };

        allowDiscards =
          mkEnableOption "TRIM/discard support for the writeback device"
          // {
            default = true;
            example = false;
          };
      };
    };
  };

  config = mkIf cfg.enable {
    system.requiredKernelConfig = [(isEnabled "ZRAM")];

    boot = {
      kernelModules = ["zram"];

      # https://github.com/pop-os/default-settings/pull/163
      kernel.sysctl = {
        "vm.swappiness" = mkDefault 180;
        "vm.watermark_boost_factor" = mkDefault 0;
        "vm.watermark_scale_factor" = mkDefault 125;
        "vm.page-cluster" = mkDefault 0;
      };
    };

    systemd.services.zram-swap = let
      inherit (cfg.writeback) encryption;
      writebackUnit = escapePath cfg.writeback.device "device";
    in {
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      before = ["swap.target"];
      wantedBy = ["swap.target"];
      bindsTo = mkIf hasWriteback [writebackUnit];
      after = mkIf hasWriteback [writebackUnit];

      path = [util-linux] ++ optional hasWriteback cryptsetup;
      script = ''
        idx=$(cat /sys/class/zram-control/hot_add)
        echo $idx > /run/zram-swap

        ${optionalString hasWriteback ''
          cryptsetup plainOpen \
            --cipher ${escapeShellArg encryption.cipher} \
            --key-size ${encryption.keySize} \
            --sector-size ${encryption.sectorSize} \
            --key-file /dev/urandom \
            ${optionalString encryption.allowDiscards "--allow-discards"} \
            ${escapeShellArg cfg.writeback.device} \
            zram$idx-writeback

          echo /dev/mapper/zram$idx-writeback > /sys/block/zram$idx/backing_dev
        ''}

        echo ${escapeShellArg cfg.algorithm} > /sys/block/zram$idx/comp_algorithm
        echo ${cfg.size} > /sys/block/zram$idx/disksize

        mkswap /dev/zram$idx
        swapon /dev/zram$idx
      '';
      preStop = ''
        idx="$(cat /run/zram-swap 2>/dev/null)" || exit 0

        swapoff /dev/zram$idx
        echo $idx > /sys/class/zram-control/hot_remove
        ${optionalString hasWriteback "cryptsetup close zram$idx-writeback"}
      '';
    };
  };
}
