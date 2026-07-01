{
  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [443];
  };

  services.caddy = {
    enable = true;

    virtualHosts."ktus.moe".extraConfig = "respond \"Not Found\" 404";
  };
}
