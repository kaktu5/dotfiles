{config, ...}: let
  inherit (config.kkts.meta) userName;
  inherit (config.security.nix-secrets.secrets) nix-access-tokens;
in {
  security.nix-secrets.secrets.nix-access-tokens = {
    group = "wheel";
    mode = "440";
  };

  persistence.users.${userName}.directories = [
    ".local/state/nix-output-monitor"
    ".local/state/tack"
  ];

  nix = {
    settings = {
      keep-derivations = true;
      keep-failed = true;
      keep-outputs = true;
    };

    extraOptions = "!include ${nix-access-tokens.path}";
  };
}
