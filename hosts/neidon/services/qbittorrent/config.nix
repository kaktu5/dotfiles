{
  config,
  lib,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.vaultix) placeholder;
  inherit (lib.kkts.formats) qsettings;

  qbittorrentConfig = {
    LegalNotice.Accepted = true;

    Preferences.WebUI = {
      Password_PBKDF2 = "@ByteArray(${placeholder.qbittorrent})";
      Username = userName;
    };
  };
in {
  vaultix = {
    secrets.qbittorrent.file = ./password.age;

    templates.qbittorrent = {
      name = "qBittorrent.conf";
      content = qsettings.generate {} qbittorrentConfig;
      owner = "qbittorrent";
      group = "qbittorrent";
      mode = "400";
    };
  };
}
