{
  config,
  lib,
  ...
}: let
  inherit (builtins) hashString;
  inherit (config.networking) hostName;
  inherit (lib.strings) substring;
in {
  imports = [./static-resolv-conf.nix];

  networking = {
    hostId = substring 0 8 (hashString "md5" hostName);

    dhcpcd.wait = "background";

    nftables.enable = true;
  };
}
