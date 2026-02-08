{
  config,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (lib) hashString;
  inherit (lib.strings) substring;
in {
  networking.hostId = hostName |> hashString "sha256" |> substring 0 8;
}
