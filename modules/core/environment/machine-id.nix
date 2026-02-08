{config, ...}: let
  inherit (builtins) hashString;
  inherit (config.networking) hostName;
in {
  environment.etc.machine-id.text = hashString "md5" hostName + "\n";

  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}
