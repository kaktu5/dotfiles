{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (lib.kkts.systemd) mkGraphicalTargetService;
  inherit (lib.meta) getExe;
  inherit (pkgs) udiskie;
in {
  hjem.users.${userName}.systemd.services.udiskie = mkGraphicalTargetService {
    serviceConfig.ExecStart = "${getExe udiskie} --notify";
  };
}
