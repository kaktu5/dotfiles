# based on https://github.com/fufexan/nix-gaming/blob/79a2e20b272c80cdff340656399369e99f55c526/modules/pipewireLowLatency.nix
{
  config,
  lib,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types.ints) positive;

  cfg = config.services.pipewire.lowLatency;

  inherit (cfg) quantum rate;
  mkIf' = mkIf cfg.enable;
  qr = "${quantum}/${rate}";
in {
  options.services.pipewire.lowLatency = {
    enable = mkEnableOption "low latency for PipeWire" // {default = true;};

    quantum = mkOption {
      type = positive;
      default = 256;
      description = "Minimum quantum to set.";
    };

    rate = mkOption {
      type = positive;
      default = 48000;
      description = "Nominal graph sample rate.";
    };
  };

  config = {
    security.rtkit = {inherit (cfg) enable;};

    services.pipewire = {
      enable = true;

      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;

      extraConfig = mkIf' {
        pipewire."90-low-latency" = {
          "context.properties"."default.clock.min-quantum" = quantum;

          "context.modules" = singleton {
            name = "libpipewire-module-rt";
            flags = [
              "ifexists"
              "nofail"
            ];
            args = {
              "nice.level" = -15;
              "rt.prio" = 88;
              "rt.time.soft" = 200000;
              "rt.time.hard" = 200000;
            };
          };
        };

        pipewire-pulse."90-low-latency"."pulse.properties" = {
          "server.address" = ["unix:native"];
          "pulse.min.req" = qr;
          "pulse.min.quantum" = qr;
          "pulse.min.frag" = qr;
        };

        client."90-low-latency"."stream.properties" = {
          "node.latency" = qr;
          "resample.quality" = 1;
        };
      };

      wireplumber.extraConfig."90-alsa-low-latency"."monitor.alsa.rules" = mkIf' (singleton {
        matches = [{"node.name" = "~alsa_output.*";}];
        actions.update-props = {
          "api.alsa.period-size" = quantum;
          "audio.rate" = rate;
        };
      });
    };
  };
}
