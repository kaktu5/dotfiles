{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;

  cfg = config.kkts.profiles.gaming;
in {
  imports = [
    ./config.nix
    ./mangohud.nix
    ./steam.nix
  ];

  options.kkts.profiles.gaming = {
    enable = mkEnableOption "gaming profile";

    mangohud.enable = mkEnableOption "mangohud" // {default = cfg.enable;};

    steam.enable = mkEnableOption "steam";
  };
}
