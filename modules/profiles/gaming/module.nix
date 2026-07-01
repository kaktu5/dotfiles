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
    ./kerbal-space-program.nix
    ./mangohud.nix
    ./minecraft.nix
    ./osu.nix
    ./steam.nix
    ./zenless-zone-zero.nix
  ];

  options.kkts.profiles.gaming = {
    enable = mkEnableOption "gaming profile";

    mangohud.enable = mkEnableOption "mangohud" // {default = cfg.enable;};

    games = mkOption {
      type = listOf <| enum ["kerbal-space-program" "minecraft" "osu" "zenless-zone-zero"];
      default = [];
    };

    steam = {
      enable = mkEnableOption "steam";

      games = mkOption {
        type = listOf <| enum ["factorio"];
        default = [];
      };
    };
  };
}
