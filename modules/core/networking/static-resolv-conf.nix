{
  config,
  lib,
  ...
}: let
  inherit (config.networking) nameservers;
  inherit (lib.strings) concatMapStringsSep;
in {
  networking = {
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";
    resolvconf.enable = false;
  };

  environment.etc."resolv.conf".text = ''
    options edns0
    ${concatMapStringsSep "\n" (ns: "nameserver ${ns}") nameservers}
  '';
}
