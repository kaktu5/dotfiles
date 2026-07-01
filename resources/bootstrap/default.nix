let
  rootDir = ../..;

  inherit (builtins) currentSystem;

  inherit (import /${rootDir}/.tack) nixpkgs;
  pkgs = nixpkgs.legacyPackages.${currentSystem};

  inherit (pkgs) gitMinimal mkShellNoCC nushell;
  inherit (pkgs.lixPackageSets.latest) lix;

  NIX_CONFIG = ''
    experimental-features = coerce-integers flakes nix-command pipe-operator
    log-format = multiline-with-logs
    log-lines = 64
    use-xdg-base-directories = true
  '';

  nushellConfig = ''
    {
      edit_mode: "vi",
      filesize: {unit: "binary"},
      show_banner: false,
      table: {mode: "none"},
    }
  '';
in
  mkShellNoCC {
    name = "dotfiles-bootstrap-devshell";

    env = {inherit NIX_CONFIG;};

    packages = [gitMinimal lix nushell];

    shellHook = "exec nu --execute '$env.config = ($env.config | merge ${nushellConfig})'";
  }
