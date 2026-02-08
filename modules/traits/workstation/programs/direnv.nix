{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.formats.nuon) closure;
  inherit (lib.meta) getExe getExe';
  inherit (pkgs) bash direnv nix-direnv uutils-coreutils-noprefix;
  inherit (pkgs.formats) toml;
in {
  users.users.${userName}.packages = [direnv];

  hjem.users.${userName} = {
    environment.sessionVariables.DIRENV_CONFIG = "${xdg.config.directory}/direnv";

    xdg.config.files = {
      "direnv/direnv.toml" = {
        generator = (toml {}).generate "direnv-direnv-toml";
        value.global = {
          bash_path = getExe bash;
          disable_stdin = true;
          strict_env = true;
          warn_timeout = "0s";
          hide_env_diff = true;
        };
      };

      "direnv/direnvrc".text = ''
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            local hash="$(echo -n "$PWD" | ${getExe' uutils-coreutils-noprefix "md5sum"})"
            echo "${xdg.cache.directory}/direnv/''${hash:0:32}"
          )}"
        }
      '';

      "direnv/lib/nix-direnv.sh".source = nix-direnv + /share/nix-direnv/direnvrc;
    };
  };

  kkts.programs.nushell.config.hooks.env_change.PWD = [
    (closure [] "direnv export json | from json | default {} | load-env")
  ];
}
