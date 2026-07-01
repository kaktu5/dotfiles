{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.generators) mkKeyValueDefault mkValueStringDefault toKeyValue;
  inherit (lib.modules) mkIf;
  inherit (lib.trivial) isBool;
  inherit (pkgs) mangohud;

  generator = toKeyValue {
    mkKeyValue = mkKeyValueDefault {
      mkValueString = v:
        if isBool v
        then
          if v
          then "1"
          else "0"
        else mkValueStringDefault {} v;
    } "=";
  };

  cfg = config.kkts.profiles.gaming.mangohud;
in
  mkIf cfg.enable {
    users.users.${userName}.packages = [mangohud];

    hjem.users.${userName}.xdg.config.files."MangoHud/MangoHud.conf" = {
      inherit generator;
      value = {
        cpu_mhz = true;
        cpu_power = true;
        cpu_temp = true;

        gpu_core_clock = true;
        gpu_power = true;
        gpu_temp = true;

        ram = true;
        proc_ram = true;
        swap = true;
        vram = true;
        proc_vram = true;

        display_server = true;
        wine = true;
        winesync = true;

        alpha = 0.75;
        round_corners = 0.0;
        font_scale = 0.75;
      };
    };
  }
