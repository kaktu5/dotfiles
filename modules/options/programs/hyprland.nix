{
  config,
  lib,
  ...
}: let
  inherit (lib.generators) toLua;
  inherit (lib.kkts.dag) entryAnywhere entryBefore resolveStr;
  inherit (lib.kkts.hyprland) bind;
  inherit (lib.lists) isList;
  inherit (lib.options) mkOption;
  inherit (lib.strings) concatMapAttrsStringSep concatMapStringsSep isString;
  inherit (lib.types) anything attrsOf either enum listOf str submodule;

  toLua' = toLua {multiline = false;};

  animationToLua = k: v: let
    animation = {leaf = k;} // v;
  in "hl.animation(${toLua' animation})";

  bindToLua = k: v: let
    norm =
      if isString v
      then bind {} v
      else if isList v
      then bind {} v
      else v;
    body =
      if isString norm.dispatcher
      then norm.dispatcher
      else "function()\n${
        norm.dispatcher |> concatMapStringsSep "\n" (d: "hl.dispatch(${d})")
      }\nend";
  in "hl.bind('${k}', ${body}, ${toLua' norm.flags})";

  curveToLua = k: v: "hl.curve('${k}', ${toLua' v})";

  eventToLua = k: v: "hl.on('${k}', ${v})";

  monitorToLua = output: attrs: let
    monitor = {inherit output;} // attrs;
  in "hl.monitor(${toLua' monitor})";

  permissionToLua = type: {
    binaries,
    mode,
  }:
    binaries |> concatMapStringsSep "\n" (binary: "hl.permission(${toLua' {inherit binary type mode;}})");

  windowRuleToLua = k: v: let
    ruleSet = {name = k;} // v;
  in "hl.window_rule(${toLua' ruleSet})";

  workspaceToLua = k: v: let
    ruleSet = {workspace = k;} // v;
  in "hl.workspace_rule(${toLua' ruleSet})";

  cfg = config.kkts.programs.hyprland;
in {
  options.kkts.programs.hyprland = {
    animations = mkOption {
      type = attrsOf anything;
    };

    binds = mkOption {
      type =
        attrsOf
        <| either str
        <| either (listOf str)
        <| submodule {
          options = {
            dispatcher = mkOption {type = either str (listOf str);};
            flags = mkOption {
              type = attrsOf anything;
              default = {};
            };
          };
        };
      default = {};
    };

    curves = mkOption {
      type = attrsOf anything;
      default = {};
    };

    config = mkOption {
      type = attrsOf anything;
      default = {};
    };

    events = mkOption {
      type = attrsOf anything;
      default = {};
    };

    monitors = mkOption {
      type = attrsOf anything;
      default = {};
    };

    permissions = mkOption {
      type = attrsOf (submodule {
        options = {
          binaries = mkOption {
            type = listOf str;
            default = [];
          };
          mode = mkOption {type = enum ["allow" "ask" "deny"];};
        };
      });
      default = {};
    };

    windowRules = mkOption {
      type = attrsOf anything;
      default = {};
    };

    workspaces = mkOption {
      type = attrsOf anything;
      default = {};
    };

    extraEntries = mkOption {
      type = attrsOf anything;
      default = {};
    };

    finalConfig = mkOption {
      type = str;
      default = let
        entries = {
          animations = entryAnywhere (cfg.animations |> concatMapAttrsStringSep "\n" animationToLua);
          binds = entryAnywhere (cfg.binds |> concatMapAttrsStringSep "\n" bindToLua);
          config = entryAnywhere "hl.config(${toLua' cfg.config})";
          curves = entryBefore ["animations"] (cfg.curves |> concatMapAttrsStringSep "\n" curveToLua);
          events = entryAnywhere (cfg.events |> concatMapAttrsStringSep "\n" eventToLua);
          monitors = entryAnywhere (cfg.monitors |> concatMapAttrsStringSep "\n" monitorToLua);
          permissions = entryAnywhere (cfg.permissions |> concatMapAttrsStringSep "\n" permissionToLua);
          windowRules = entryAnywhere (cfg.windowRules |> concatMapAttrsStringSep "\n" windowRuleToLua);
          workspaces = entryAnywhere (cfg.workspaces |> concatMapAttrsStringSep "\n" workspaceToLua);
        };
      in
        resolveStr (entries // cfg.extraEntries);
      readOnly = true;
    };
  };
}
