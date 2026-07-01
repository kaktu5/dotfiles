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
        isNormalUser = true;
        uid = 1000;
        home = "/var/home";
        extraGroups = ["wheel"];
      };
    };
  };
}
