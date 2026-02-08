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
  inherit (inputs.tuigreet.packages.${system}) tuigreet;
  inherit (lib.meta) getExe;
  inherit (pkgs) hyprland;
  inherit (pkgs.writers) writeTOML;
in {
  systemd.tmpfiles.rules = [
    "d /var/cache/tuigreet 0755 greeter greeter -"
    "F /var/cache/tuigreet/lastuser 0644 greeter greeter - ${userName}"
    "F /var/cache/tuigreet/lastsession-path 0644 greeter greeter - ${hyprland}/share/wayland-sessions/hyprland-uwsm.desktop"
  ];

  environment.etc."tuigreet/config.toml".source = writeTOML "tuigreet-config.toml" {
    display = {
      show_time = true;
      time_format = "%a, %b %d, %H:%M:%S";
    };

    layout.width = 48;

    remember = {
      username = true;
      session = true;
    };

    secret.mode = "characters";

    session.sessions_dirs = sessionPackages |> map (pkg: pkg + /share/wayland-sessions);

    power.use_setsid = true;
  };

  services.greetd.settings.default_session.command = getExe tuigreet;
}
