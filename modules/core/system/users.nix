{config, ...}: let
  inherit (config.kkts.meta) userName;

  home = "/var/home";
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
        inherit home;
        extraGroups = ["wheel"];
      };
    };
  };

  # not `users.users.${userName}.home`, that forces `users.users`,
  # which pulls in `fileSystems` via `boot.supportedFilesystems`, which
  # infinitely recurses if hjem's `xdg.*.directory` is used in `fileSystems.<name>`
  hjem.users.${userName}.directory = home;
}
