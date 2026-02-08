{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.generators) toGitINI;
  inherit (lib.meta) getExe;
  inherit (pkgs) git jujutsu;
  inherit (pkgs.writers) writeTOML;

  user = {
    name = "kaktu5";
    email = "108426150+kaktu5@users.noreply.github.com";
  };

  gpg = getExe pkgs.gnupg;
in {
  users.users.${userName}.packages = [git jujutsu];

  hjem.users.${userName}.xdg.config.files = {
    "jj/config.toml" = {
      generator = writeTOML "jj-config-toml";
      value = {
        inherit user;

        ui = {
          default-command = "status";
          paginate = "never";
        };

        signing = {
          behavior = "own";
          backend = "gpg";
          backends.gpg.program = gpg;
        };

        aliases = {
          fresh = ["new" "trunk()"];
          tug = ["bookmark" "move" "--from" "heads(::@- & bookmarks())" "--to" "@-"];

          clone = ["git" "clone"];
          fetch = ["git" "fetch"];
          init = ["git" "init"];
          push = ["git" "push"];
          remote = ["git" "remote"];
        };
      };
    };

    "git/config" = {
      generator = toGitINI;
      value = {
        inherit user;

        commit.gpgsign = true;
        gpg.openpgp.program = gpg;

        url."git@github.com:".insteadOf = "github:";
      };
    };
  };
}
