{config, ...}: let
  inherit (config.kkts.keys.users) kaktu5;
in {
  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [443];
  };

  services.caddy = {
    enable = true;

    virtualHosts = {
      "ktus.moe".extraConfig = ''
        header Content-Type text/plain
        respond "Not Found" 404
      '';

      "ssh.ktus.moe".extraConfig = ''
        header Content-Type text/plain
        respond <<KEYS
        ${kaktu5}
        KEYS 200
      '';
    };
  };
}
