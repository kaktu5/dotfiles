{config, ...}: let
  inherit (config.kkts.meta) userName;
in {
  users = {
    mutableUsers = false;

    defaultUserShell = "/run/current-system/sw/bin/nologin";

    users = {
      # disable root login
      root.hashedPassword = "!";

      ${userName} = {
        uid = 1000;
        isNormalUser = true;
        extraGroups = ["wheel"];
      };
    };
  };
}
