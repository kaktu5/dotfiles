{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.users.users) kkts;
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkDefault;

  agretty = getExe' pkgs.greetd "agretty";
  shell = getExe kkts.shell;
in {
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      user = "greeter";
      command = mkDefault "${agretty} --cmd ${shell}";
    };
  };
}
