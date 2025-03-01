{
  config,
  lib,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) concatStringsSep mapAttrsToList mkOption pipe;
  inherit (lib.types) attrs;
  cfg = config.kkts.sessionVariables;
in {
  options.kkts.sessionVariables = mkOption {type = attrs;} // {default = {};};
  config.home.files.".config/uwsm/env".text = pipe cfg [
    (mapAttrsToList (name: value: "export ${name}=${toString value}"))
    (concatStringsSep "\n")
  ];
}
