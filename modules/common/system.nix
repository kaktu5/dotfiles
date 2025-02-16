{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.system) timezone username;
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str;
in {
  options.kkts.system = {
    username = mkOption {type = str;} // {default = "kkts";};
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
    time.timeZone = timezone;
    system.stateVersion = "24.11";
  };
}
