{
  config,
  lib,
  ...
}: let
  inherit (builtins) hashString;
  inherit (config.networking) hostName;
  inherit (lib.strings) substring;
  inherit (lib.trivial) fromHexString;
in {
  microvm = {
    hypervisor = "cloud-hypervisor";

    vsock.cid = hostName |> hashString "md5" |> substring 0 8 |> fromHexString;
  };
}
