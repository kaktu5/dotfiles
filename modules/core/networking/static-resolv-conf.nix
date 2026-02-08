{
  config,
  lib,
  ...
}: let
  inherit (config.networking) nameservers;
  inherit (lib.strings) concatMapStringsSep;
in {
  services.resolved.enable = false;

  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
  };

  environment.etc."resolv.conf".text = ''
    options edns0
    ${concatMapStringsSep "\n" (ns: "nameserver ${ns}") nameservers}
  '';

  boot.initrd = {
    services.resolved.enable = false;

    systemd.contents."/etc/resolv.conf".text = ''
      nameserver 127.0.0.1
      nameserver ::1
    '';
  };
}
