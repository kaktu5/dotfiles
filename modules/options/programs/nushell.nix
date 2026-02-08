{
  config,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.kkts.dag) entryAnywhere resolveStr;
  inherit (lib.kkts.formats.nuon) generate;
  inherit (lib.options) mkOption;
  inherit (lib.strings) concatLines;
  inherit (lib.types) anything attrsOf str;

  cfg = config.kkts.programs.nushell;
in {
  options.kkts.programs.nushell = {
    env = mkOption {
      type = attrsOf anything;
      default = {};
    };

    config = mkOption {
      type = attrsOf anything;
      default = {};
    };

    aliases = mkOption {
      type = attrsOf str;
      default = {};
    };

    extraEntries = mkOption {
      type = attrsOf anything;
      default = {};
    };

    finalConfig = mkOption {
      type = str;
      default = let
        env = entryAnywhere "load-env ${generate {} cfg.env}";
        config = entryAnywhere "$env.config = $env.config | merge deep ${generate {} cfg.config}";
        aliases =
          cfg.aliases
          |> mapAttrsToList (k: v: "alias ${k} = (${v})")
          |> concatLines
          |> entryAnywhere;
      in
        resolveStr ({inherit env config aliases;} // cfg.extraEntries);
      readOnly = true;
    };
  };
}
