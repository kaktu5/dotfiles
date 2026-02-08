{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vaultix) templates;
  inherit (lib.lists) singleton;
  inherit (pkgs) qbittorrent;
in {
  imports = [./config.nix];

  preservation.preserveAt."/persist".directories = singleton {
    directory = "/var/lib/qBittorrent/qBittorrent";
    user = "qbittorrent";
    group = "qbittorrent";
    mode = "755";
  };

  services.qbittorrent = {
    enable = true;
    package = qbittorrent.override {guiSupport = false;};
    openFirewall = true;
  };

  systemd.services.qbittorrent.preStart = let
    configDir = "/var/lib/qBittorrent/qBittorrent/config";
  in ''
    mkdir -p ${configDir}
    ln -sf ${templates.qbittorrent.path} ${configDir}/qBittorrent.conf
  '';
}
