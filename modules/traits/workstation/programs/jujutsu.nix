{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.hjem.users.${userName}.environment.sessionVariables) EDITOR;
  inherit (config.kkts.meta) userName;
  inherit (lib.generators) toGitINI;
  inherit (pkgs) gitMinimal jujutsu;
  inherit (pkgs.writers) writeTOML writeText;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = ["${xdg.config.directory}/jj/repos"];

  users.users.${userName}.packages = [gitMinimal jujutsu];

  hjem.users.${userName}.xdg.config.files = {
    "jj/config.toml" = {
      generator = writeTOML "jj-config-toml";
      value = {
        user = {
          name = "kaktu5";
          email = "108426150+kaktu5@users.noreply.github.com";
        };

        # TODO:
        # templates.draft_commit_description =

        ui = {
          default-command = "status";
          paginate = "never";
          editor = EDITOR;
        };

        # TODO: sign using Sequoia-PGP
        # signing = {};

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
        core.excludesFile = writeText "gitignore" "/.jj/";

        url = {
          "git@github.com:".insteadOf = "github:";

          "https://codeberg.org/".insteadOf = "codeberg:";
          "https://gitlab.com/".insteadOf = "gitlab:";
        };
      };
    };
  };
}
