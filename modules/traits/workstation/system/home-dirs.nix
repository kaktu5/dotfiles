{
  config,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.generators) toKeyValue;
  inherit (lib.lists) isList;
  inherit (lib.strings) removePrefix;

  mapWithBase = prefix: value:
    if isList value
    then value |> map (dir: "${prefix}/${dir}")
    else value |> mapAttrs (_: dir: "${prefix}/${dir}");
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
    ++ mapWithBase xdg.data.directory [
      "cargo"
      "gradle"
    ];

  hjem.users.${userName} = {
    environment.sessionVariables = mapWithBase xdg.data.directory {
      CARGO_HOME = "cargo";
      GRADLE_USER_HOME = "gradle";
    };

    xdg.config.files."user-dirs.dirs" = {
      generator = toKeyValue {mkKeyValue = k: v: "${k}='${v}'";};
      value = mapWithBase home {
        XDG_DOCUMENTS_DIR = "documents";
        XDG_DOWNLOAD_DIR = "downloads";
        XDG_MUSIC_DIR = "music";
        XDG_PICTURES_DIR = "images";
        XDG_PROJECTS_DIR = "projects";
        XDG_VIDEOS_DIR = "videos";
      };
    };
  };

  systemd.tmpfiles.rules = ["L+ /etc/nixos/flake.nix - - - - ${home}/dotfiles/flake.nix"];
}
