{lib, ...}: let
  inherit (lib) singleton;
in {
  environment.persistence."/persist/root".directories = [];
  networking.firewall.allowedTCPPorts = [3000];
  services = {
    grafana = {
      enable = true;
      settings.server.http_addr = "0.0.0.0";
    };
    prometheus = {
      enable = true;
      scrapeConfigs = singleton {
        job_name = "node_exporter";
        static_configs = [{targets = ["127.0.0.1:9100"];}];
      };
      exporters.node = {
        enable = true;
        enabledCollectors = ["processes" "systemd"];
      };
    };
  };
}
