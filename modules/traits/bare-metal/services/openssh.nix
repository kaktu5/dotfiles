{
  config,
  lib,
  ...
}: let
  inherit (config.kkts) keys;
  inherit (config.kkts.meta) userName;
  inherit (lib.lists) singleton;
in {
  users.users.${userName}.openssh.authorizedKeys.keys = [keys.users.${userName}];

  services.openssh = {
    enable = true;
    allowSFTP = false;

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
