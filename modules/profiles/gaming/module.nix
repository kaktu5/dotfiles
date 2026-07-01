{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) enum listOf;

  cfg = config.kkts.profiles.gaming;
in {
  imports = [
    ./config.nix
    ./mangohud.nix
    ./osu.nix
    ./steam.nix
    ./zenless-zone-zero.nix
  ];

  options.kkts.profiles.gaming = {
    enable = mkEnableOption "gaming profile";

    mangohud.enable = mkEnableOption "mangohud" // {default = cfg.enable;};

    osu.enable = mkEnableOption "osu! Tachyon";

    steam = {
      enable = mkEnableOption "steam";

      games = mkOption {
        type = listOf <| enum ["factorio"];
        default = [];
      };
    };

    zenlessZoneZero.enable = mkEnableOption "Zenless Zone Zero";
  };
}
