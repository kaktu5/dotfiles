let
  # https://github.com/scsibug/nostr-rs-relay/issues/198
  address = "127.0.0.1";
  port = 12849;
in {
  services = {
    caddy.virtualHosts."nostr-relay.ktus.moe".extraConfig = ''
      respond /metrics 404
      reverse_proxy ${address}:${port}
    '';

    nostr-rs-relay = {
      enable = true;

      settings = {
        info = {
          relay_url = "wss://nostr-relay.ktus.moe";
          name = "moe-ktus-nostr";
        };

        network = {
          inherit address port;
          remote_ip_header = "x-forwarded-for";
        };

        database.in_memory = true;

        limits = {
          messages_per_sec = 5;
          subscriptions_per_min = 10;
          limit_scrapers = true;
        };
      };
    };
  };
}
