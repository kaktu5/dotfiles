let
  rootDir = ../..;

  inherit (builtins) currentSystem;

  inherit (import /${rootDir}/.tack) nixpkgs;
  pkgs = nixpkgs.legacyPackages.${currentSystem};

  inherit (pkgs) gitMinimal mkShellNoCC nushell;
  inherit (pkgs.lixPackageSets.latest) lix;
in
  mkShellNoCC {
    name = "dotfiles-bootstrap-devshell";

    env.NIX_CONFIG = ''
      experimental-features = coerce-integers flakes nix-command pipe-operator
      log-format = multiline-with-logs
      log-lines = 64
      use-xdg-base-directories = true
    '';

    packages = [gitMinimal lix nushell];

    shellHook = "exec nu";
  }
