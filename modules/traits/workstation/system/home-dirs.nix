{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toKeyValue;
  inherit (lib.kkts.paths) prefixEach;
in {
  persistence.users.${userName}.directories = [
    {
      target = "projects";
      mountOptions = ["exec"];
    }
    "documents"
    "dotfiles"
    "downloads"
    "images"
    "music"
    "videos"

    ".local/share/cargo"
    ".local/share/gradle"
  ];

  hjem.users.${userName} = {
    environment.sessionVariables = {
      CARGO_HOME = "${home}/.local/share/cargo";
      GRADLE_USER_HOME = "${home}/.local/share/gradle";
    };

    xdg.config.files."user-dirs.dirs" = {
      generator = toKeyValue {mkKeyValue = k: v: "${k}=\"${v}\"";};
      value = prefixEach home {
        XDG_DOCUMENTS_DIR = "documents";
        XDG_DOWNLOAD_DIR = "downloads";
        XDG_MUSIC_DIR = "music";
        XDG_PICTURES_DIR = "images";
        XDG_PROJECTS_DIR = "projects";
        XDG_VIDEOS_DIR = "videos";
      };
    };
  };
}
