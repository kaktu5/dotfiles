{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}.xdg) cache;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.theme.colors) hex';
  inherit (lib.kkts.dag) entryAnywhere;
  inherit (lib.meta) getExe;
  inherit (pkgs) runCommand starship writeCBin;
  inherit (pkgs.formats) toml;

  nixShellLevel = writeCBin "nix-shell-level" ''
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int main() {
      const char *level = getenv("NIX_SHELL_LEVEL");
      if (level != nullptr && strcmp(level, "1") != 0) {
        printf("[%s]", level);
        fflush(stdout);
      }

      return EXIT_SUCCESS;
    }
  '';

  starship-nu = runCommand "starship.nu" {} "${getExe starship} init nu > $out";
in {
  users.users.${userName}.packages = [starship];

  hjem.users.${userName} = {
    environment.sessionVariables.STARSHIP_CACHE = "${cache.directory}/starship";

    xdg.config.files."starship.toml" = {
      generator = (toml {}).generate "starship-toml";
      value = {
        format = "$username@$hostname$directory$nix_shell\${custom.nix_shell_level}$git_branch$status$cmd_duration\n$character";
        add_newline = false;

        username = {
          show_always = true;
          format = "[$user](fg:${hex'.purple})";
        };

        hostname = {
          ssh_only = false;
          format = "[$hostname](fg:${hex'.purple})[$ssh_symbol](fg:${hex'.fg0})";
          ssh_symbol = " ";
        };

        directory = {
          format = " [$read_only](fg:${hex'.fg0})[$path](fg:${hex'.purple})";
          read_only = " ";
        };

        nix_shell.format = " [󱄅 shell](fg:${hex'.blue})";

        custom.nix_shell_level = {
          when = true;
          shell = getExe nixShellLevel;
          format = "[$output](fg:${hex'.blue})";
        };

        git_branch.format = " [ $branch](fg:${hex'.red})";

        status = {
          disabled = false;
          format = " [ $int](fg:${hex'.red})";
        };

        cmd_duration.format = " [$duration](fg:${hex'.fg0})";

        character.format = "[󰘧 ](fg:${hex'.fg0})";
      };
    };
  };

  kkts.programs.nushell = {
    config.cursor_shape = {
      vi_insert = "line";
      vi_normal = "block";
    };

    extraEntries = {
      nixLvl = entryAnywhere ''
        mut nix_lvl = ""
        if ($env | get NIX_SHELL_LEVEL? | is-not-empty) and ($env.NIX_SHELL_LEVEL != "1") {
          $nix_lvl = $env.NIX_SHELL_LEVEL
        }
        $env.NIX_LVL = $nix_lvl
      '';

      starship = entryAnywhere ''
        # https://github.com/starship/starship/issues/5423
        load-env {
          PROMPT_INDICATOR_VI_INSERT: "",
          PROMPT_INDICATOR_VI_NORMAL: "",
        }
        source ${starship-nu}
      '';
    };
  };
}
