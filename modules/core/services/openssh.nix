# https://blog.stribik.technology/2015/01/04/secure-secure-shell.html
# https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67
# https://www.openssh.org/pq.html
{lib, ...}: let
  inherit (lib.lists) singleton;
in {
  services.openssh = {
    enable = true;
    allowSFTP = false;
    ports = [32];

    settings = {
      PermitRootLogin = "no";

      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 3;

      # X11 in the Big 2026?
      X11Forwarding = false;

      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;

      LogLevel = "VERBOSE";

      KexAlgorithms = [
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512@openssh.com"
      ];

      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
      ];

      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
      ];
    };

    hostKeys = singleton {
      path = "/persist/etc/ssh/host-key";
      type = "ed25519";
    };
  };
}
