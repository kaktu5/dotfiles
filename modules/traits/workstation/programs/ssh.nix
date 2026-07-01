{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts) keys;
  inherit (config.kkts.meta) userName;
  inherit (config.security.nix-secrets.secrets) kaktu5-key;
  inherit (config.services.openssh.settings) Ciphers KexAlgorithms Macs;
  inherit (lib.kkts.generators) toSshConfig;
  inherit (lib.lists) singleton;
  inherit (pkgs) openssh;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = singleton {
    directory = ".ssh";
    mode = "700";
  };

  users.users.${userName}.packages = [openssh];

  programs.ssh = {
    startAgent = true;

    agentTimeout = "15m";

    # vendor keys to avoid MitM attacks
    knownHosts."github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    ciphers = Ciphers;
    kexAlgorithms = KexAlgorithms;
    macs = Macs;
  };

  hjem.users.${userName}.files = {
    ".ssh/${userName}-key.pub" = {
      text = keys.users.${userName};
      type = "copy";
      permissions = "644";
    };

    ".ssh/config" = {
      generator = toSshConfig {};
      value."*" = {
        AddKeysToAgent = true;
        IdentityFile = kaktu5-key.path;
        IdentitiesOnly = true;
      };
      type = "copy";
      permissions = "600";
    };
  };
}
