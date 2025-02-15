# TODO:
# - persist /var/lib/synthing with correct permissions
/*
{config, ...}: let
  inherit (config.kkts.system) username;
  inherit (config.home-manager.users.${username}.home) homeDirectory;
  inherit (builtins) listToAttrs map;
  sharedDirs = [ "documents" "downloads" "music" "pictures" "videos" "dotfiles" "git"]
    |> map (dirName: {
      name = dirName;
      value = {
        path = homeDirectory + "/" + dirName;
        devices = ["Nothing Phone (1)"];
      };
    })
    |> listToAttrs;
in {
  services.syncthing = {
    enable = true;
    relay.enable = true;
    openDefaultPorts = true;
    user = username;
    databaseDir = "/var/lib/syncthing";
    dataDir = homeDirectory;
    configDir = homeDirectory + "/.config/syncthing";
    settings = {
      folders = sharedDirs;
      devices = {
        "Nothing Phone (1)" = {
          id = "EQS5QBG-D7YIVNA-DD6QEDW-YTUNOXL-QOYFPGP-WKSGEZF-QGFYCDZ-MDA2AAY";
        };
      };
    };
  };
  systemd.tmpfiles.rules = ["d /var/lib/syncthing 0755 kkts kkts - -"];
}
*/
_: {}
