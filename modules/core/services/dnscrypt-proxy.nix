# https://github.com/quad9dns/dnscrypt-settings/blob/main/dnscrypt/quad9-resolvers-dnscrypt.md
# https://github.com/dnscrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-dnscrypt-proxy.toml
{
  config,
  lib,
  sources,
  ...
}: let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.kkts.formats) dnsCryptStamps;
  inherit (lib.strings) readFile;
  inherit (sources) dnscrypt-settings oisd;

  quad9Stamps = dnsCryptStamps.parse <| readFile (dnscrypt-settings + /dnscrypt/quad9-resolvers-dnscrypt.md);

  cfg = config.services.dnscrypt-proxy.settings;
in {
  networking = {
    nameservers = ["127.0.0.1" "::1"];

    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager.dns = "none";

    # prevent DNS leaks, all DNS queries must go through dnscrypt-proxy
    nftables.tables.dnscrypt-proxy = {
      family = "inet";
      content = ''
        chain output {
          type filter hook output priority 0; policy accept;

          # allow localhost DNS queries
          ip daddr 127.0.0.1 udp dport 53 accept
          ip6 daddr ::1 udp dport 53 accept
          ip daddr 127.0.0.1 tcp dport 53 accept
          ip6 daddr ::1 tcp dport 53 accept

          # drop all other DNS traffic
          udp dport {53, 853} drop
          tcp dport {53, 853} drop
        }
      '';
    };
  };

  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = false;
    settings = {
      listen_addresses = ["127.0.0.1:53" "[::1]:53"];

      server_names = [
        "dnscrypt-ip4-nofilter-pri"
        "dnscrypt-ip4-nofilter-alt"
        "dnscrypt-ip6-nofilter-pri"
        "dnscrypt-ip6-nofilter-alt"
      ];
      static = genAttrs cfg.server_names (name: {stamp = quad9Stamps.${name};});

      blocked_names.blocked_names_file = oisd + /domainswild_big.txt;

      dnscrypt_ephemeral_keys = true;

      cache_size = 8192;
      cache_min_ttl = 60 * 60;
    };
  };
}
