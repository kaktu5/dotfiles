{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (lib) hashString;
  inherit (lib.strings) substring;
in {
  environment.etc.machine-id.text = (hostName |> hashString "sha256" |> substring 0 32) + "\n";

  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}
