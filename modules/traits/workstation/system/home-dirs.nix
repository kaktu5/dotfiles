{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toKeyValue;
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
  ];

  hjem.users.${userName}.xdg.config.files."user-dirs.dirs" = {
    generator = toKeyValue {mkKeyValue = k: v: "${k}=\"${v}\"";};
    value = {
      XDG_DOCUMENTS_DIR = "${home}/documents";
      XDG_DOWNLOAD_DIR = "${home}/downloads";
      XDG_MUSIC_DIR = "${home}/music";
      XDG_PICTURES_DIR = "${home}/images";
      XDG_PROJECTS_DIR = "${home}/projects";
      XDG_VIDEOS_DIR = "${home}/videos";
    };
  };
}
