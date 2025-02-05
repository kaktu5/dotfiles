{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.system) hostname timezone username;
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str;
  inherit (pkgs) system;
in {
  options.kkts.system = {
    username = mkOption {type = str;} // {default = "kkts";};
    hostname = mkOption {type = str;};
    timezone = mkOption {type = nullOr str;} // {default = "Europe/Warsaw";};
  };
  config = {
    users = {
      mutableUsers = false;
      users.${username} = {
        isNormalUser = true;
        extraGroups = ["wheel"];
      };
    };
    networking.hostName = hostname;
    nixpkgs.hostPlatform = system;
    time.timeZone = timezone;
    system.stateVersion = "24.11";
  };
}
