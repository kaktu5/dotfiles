{config, ...}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.security.nix-secrets.secrets) nix-access-tokens;
in {
  security.nix-secrets.secrets.nix-access-tokens = {
    group = "wheel";
    mode = "440";
  };

  preservation.preserveAt."/persist".users.${userName}.directories = ["${xdg.state.directory}/nix-output-monitor"];

  nix = {
    settings = {
      keep-derivations = true;
      keep-failed = true;
      keep-outputs = true;
    };

    extraOptions = "!include ${nix-access-tokens.path}";
  };
}
