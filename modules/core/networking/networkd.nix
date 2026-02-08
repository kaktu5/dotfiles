{
  boot.kernel.sysctl.use_tempaddr = 2;

  networking.useNetworkd = true;

  systemd.network.links."10-mac-random" = {
    matchConfig.Type = "ether wlan wwan";

    linkConfig.MACAddressPolicy = "random";
  };

  systemd.network.networks."10-anonymous-dhcp" = {
    matchConfig.Name = "en* wl* ww*";

    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;

      IPv6PrivacyExtensions = "kernel";
      IPv6LinkLocalAddressGenerationMode = "stable-privacy";
    };

    ipv6AcceptRAConfig.Token = "prefixstable";

    dhcpV4Config.Anonymize = true;
  };
}
