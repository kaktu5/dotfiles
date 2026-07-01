{lib, ...}: let
  inherit (lib.options) mkEnableOption;
in {
  imports = [
    ./steam.nix
  ];

  options.kkts.profiles.gaming = {
    steam.enable = mkEnableOption "steam";
  };
}
