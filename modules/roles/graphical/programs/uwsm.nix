{
  config,
  lib,
  ...
}: let
  inherit (config.hjem.users.${userName}.environment) sessionVariables;
  inherit (config.kkts.meta) userName;
  inherit (lib.strings) concatMapAttrsStringSep;
in {
  hjem.users.${userName}.xdg.config.files."uwsm/env".text =
    sessionVariables |> concatMapAttrsStringSep "\n" (n: v: "export ${n}='${v}'");
}
