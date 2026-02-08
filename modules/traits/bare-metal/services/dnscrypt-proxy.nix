{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (inputs) dnscrypt-settings oisd;
  inherit (lib.attrsets) genAttrs listToAttrs nameValuePair;
  inherit (lib.lists) filter ifilter0 zipListsWith;
  inherit (lib.strings) hasPrefix readFile removePrefix splitString trim;
  inherit (lib.trivial) mod;

  parse = str: let
    lines =
      str
      |> splitString "\n"
      |> filter (l: hasPrefix "##" l || hasPrefix "sdns://" l);

    headers =
      lines
      |> ifilter0 (i: _: mod i 2 == 0)
      |> map (removePrefix "##")
      |> map trim;
    stamps =
      lines
      |> ifilter0 (i: _: mod i 2 == 1)
      |> map trim;
  in
    zipListsWith nameValuePair headers stamps |> listToAttrs;

  quad9Stamps = parse <| readFile "${dnscrypt-settings}/dnscrypt/quad9-resolvers-dnscrypt.md";

  cfg = config.services.dnscrypt-proxy.settings;
in {
  networking = {
    nameservers = ["127.0.0.1" "::1"];

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

      dnscrypt_ephemeral_keys = true;

      block_unqualified = true;
      block_undelegated = true;
      blocked_names.blocked_names_file = "${oisd}/domainswild_big.txt";

      cache_size = 8192;
      cache_min_ttl = 15 * 60;
      cache_max_ttl = 12 * 60 * 60;
      cache_neg_min_ttl = 60;
      cache_neg_max_ttl = 15 * 60;

      nx_log = {
        file = "/dev/stdout";
        format = "ltsv";
      };
    };
  };
}
