{
  config,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toKeyValue;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = [
    "documents"
    "dotfiles"
    "downloads"
    "music"
    "pictures"
    "projects"
    "videos"
  ];

  hjem.users.${userName} = {
    environment.sessionVariables = {
      CARGO_HOME = xdg.data.directory + "/cargo";
      GRADLE_USER_HOME = xdg.data.directory + "/gradle";
    };

    xdg.config.files."user-dirs.dirs" = {
      generator = toKeyValue {mkKeyValue = k: v: "${k}=\"${v}\"";};
      value = {
        XDG_DOCUMENTS_DIR = home + "/documents";
        XDG_DOWNLOAD_DIR = home + "/downloads";
        XDG_MUSIC_DIR = home + "/music";
        XDG_PICTURES_DIR = home + "/pictures";
        XDG_VIDEOS_DIR = home + "/videos";
        XDG_DESKTOP_DIR = home;
        XDG_PUBLICSHARE_DIR = home;
        XDG_TEMPLATES_DIR = home;
      };
    };
  };

  systemd.tmpfiles.rules = ["L+ /etc/nixos/flake.nix - - - - ${home}/dotfiles/flake.nix"];
}
