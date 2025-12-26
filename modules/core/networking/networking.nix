{
  config,
  lib,
  ...
}: let
  inherit (builtins) hashString;
  inherit (config.networking) hostName;
  inherit (lib.strings) substring;
in {
  networking.hostId = substring 0 8 (hashString "md5" hostName);
}
