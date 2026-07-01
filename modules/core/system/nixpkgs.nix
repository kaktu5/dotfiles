{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.lists) singleton;
in {
  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;

    permittedInsecurePackages = ["radicle-node-1.10.3"];
  };

  assertions = singleton {
    assertion = pkgs.radicle-node.version == "1.10.3";
    message = "remove radicle-node-1.10.3 from permittedInsecurePackages";
  };
}
