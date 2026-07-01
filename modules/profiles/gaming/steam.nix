{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toJSON;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkIf;
  inherit (pkgs) proton-ge-bin steamWithMillennium;

  # based on https://github.com/saygo-png/nixos/blob/74f5016059374be45b27f44744fc346363c99146/modules/xdgDirsEnforcement.nix
  package = steamWithMillennium.override {
    extraBwrapArgs =
      ["--bind ${home}/.local/share/steam ${home}"]
      ++ map (dir: "--ro-bind ${home}/${dir} ${home}/${dir}") [
        ".config/MangoHud"
        ".config/mimeapps.list"
        ".config/pulse"
        ".config/user-dirs.dirs"
      ]
      ++ map (dir: "--bind ${home}/${dir} ${home}/${dir}") [
        ".local/cache/mesa_shader_cache"
        ".local/cache/radv_builtin_shaders"
        "games"
      ]
      ++ [
        "--setenv XDG_CACHE_HOME ${home}/.local/cache"
        "--setenv XDG_CONFIG_HOME ${home}/.config"
        "--setenv XDG_DATA_HOME ${home}/.local/share"
        "--setenv XDG_STATE_HOME ${home}/.local/state"
      ];
  };
in
  mkIf (gaming.enable && gaming.steam.enable) {
    persistence.users.${userName}.directories = singleton {
      target = ".local/share/steam";
      mountOptions = ["exec"];
    };

    programs.steam = {
      enable = true;
      inherit package;

      localNetworkGameTransfers.openFirewall = true;

      extraCompatPackages = [proton-ge-bin];
    };

    hjem.users.${userName}.xdg.data.files."steam/.config/millennium/config.json" = {
      generator = toJSON {};
      value.misc.hasShownWelcomeModal = true;
    };
  }
