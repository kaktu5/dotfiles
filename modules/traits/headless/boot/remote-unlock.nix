{config, ...}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}.openssh.authorizedKeys) keys;
in {
  boot.initrd = {
    systemd = {
      network.enable = true;

      users.root.shell = "/usr/bin/systemd-tty-ask-password-agent";
    };

    network.ssh = {
      enable = true;
      port = 36;
      hostKeys = ["/persist/etc/initrd/ssh/host-key"];
      authorizedKeys = keys;
    };
  };
}
