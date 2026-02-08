{
  config,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment) sessionVariables;
  inherit (config.kkts.meta) userName;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatLines escapeShellArg;
in {
  hjem.users.${userName}.xdg.config.files."nushell/env.nu".text =
    sessionVariables
    |> mapAttrsToList (k: v: "$env.${k} = \"${escapeShellArg v}\"")
    |> concatLines;
}
