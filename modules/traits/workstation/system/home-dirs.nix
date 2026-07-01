{
  config,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toKeyValue;
  inherit (lib.kkts.paths) prefixEach;
in {
  preservation.preserveAt."/persist".users.${userName}.directories =
    [
      {
        directory = "projects";
        mountOptions = ["exec"];
      }
      "documents"
      "dotfiles"
      "downloads"
      "images"
      "music"
      "videos"
    ]
    ++ prefixEach xdg.data.directory [
      "cargo"
      "gradle"
    ];

  hjem.users.${userName} = {
    environment.sessionVariables = prefixEach xdg.data.directory {
      CARGO_HOME = "cargo";
      GRADLE_USER_HOME = "gradle";
    };

    xdg.config.files."user-dirs.dirs" = {
      generator = toKeyValue {mkKeyValue = k: v: "${k}='${v}'";};
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
