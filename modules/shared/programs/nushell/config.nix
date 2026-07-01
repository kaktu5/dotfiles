{
  config,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment) sessionVariables;
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.dag) entryAnywhere;
in {
  kkts.programs.nushell = {
    env = sessionVariables;

    config = {
      history = {
        file_format = "sqlite";
        max_size = 16 * 1024;
        sync_on_enter = true;
        isolation = true;
      };

      show_banner = false;
      recursion_limit = 2 * 1024;

      edit_mode = "vi";
      cursor_shape.vi_normal = "block";

      footer_mode = 24;
      table = {
        mode = "none";
        padding = {
          left = 0;
          right = 1;
        };
        missing_value_symbol = "-";
      };

      filesize = {
        unit = "binary";
        show_unit = true;
        precision = 2;
      };

      ls.use_ls_colors = false;

      highlight_resolved_externals = true;
    };

    extraEntries = {
      ls = entryAnywhere ''
        def ls [...paths: oneof<glob, string>]: nothing -> table {
          let paths = $paths | default --empty [.]
          %ls --all --long ...$paths
          | select name type mode user group size modified
          | sort-by type name
        }
      '';

      run0 = entryAnywhere ''
        def --wrapped run0 [...args] {
          let command = $"$in | from nuon | ($args | str join " ") | to nuon"
          $in
          | default null
          | to nuon
          | ^run0 --background "" --pipe -- nu --stdin --config $nu.config-path --commands $command
          | from nuon
        }
      '';
    };
  };
}
