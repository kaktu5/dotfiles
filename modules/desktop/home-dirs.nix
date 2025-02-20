{config, ...}: let
  inherit (config.kkts.system) username;
  inherit (config.home-manager.users.${username}.home) homeDirectory;
in {
  home-manager.users.${username}.xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${homeDirectory}";
    documents = "${homeDirectory}/documents";
    download = "${homeDirectory}/downloads";
    music = "${homeDirectory}/music";
    pictures = "${homeDirectory}/pictures";
    publicShare = "${homeDirectory}";
    templates = "${homeDirectory}";
    videos = "${homeDirectory}/videos";
  };
  environment.variables = {
    FLAKE = "${homeDirectory}/dotfiles";
    XDG_DATA_HOME = "${homeDirectory}/.local/share";
    XDG_CONFIG_HOME = "${homeDirectory}/.config";
    XDG_CACHE_HOME = "${homeDirectory}/.cache";
    XDG_STATE_HOME = "${homeDirectory}/.local/state";
  };
}
