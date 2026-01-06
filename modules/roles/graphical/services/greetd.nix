{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.nixpkgs.hostPlatform) system;
  inherit (config.services.displayManager) sessionPackages;
  inherit (lib.lists) map singleton;
  inherit (lib.meta) getExe;
  inherit (pkgs.writers) writeTOML;

  inherit (inputs.tuigreet.packages.${system}) tuigreet;
in {
  preservation.preserveAt."/persist".directories = singleton {
    directory = "/var/cache/tuigreet";
    mode = "755";
    user = "greeter";
    group = "greeter";
  };

  environment.etc."tuigreet/config.toml".source = writeTOML "tuigreet-config.toml" {
    display = {
      show_time = true;
      time_format = "%a, %b %d, %H:%M:%S";
    };

    layout.width = 48;

    remember = {
      default_user = userName;
      username = true;
      session = true;
    };

    secret.mode = "characters";

    session.sessions_dirs = sessionPackages |> map (pkg: pkg + /share/wayland-sessions);

    power.use_setsid = true;
  };

  services.greetd.settings.default_session.command = getExe tuigreet;
}
