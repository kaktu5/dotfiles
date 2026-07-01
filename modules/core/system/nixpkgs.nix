{
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.kaktu5pkgs.overlays) kaktu5pkgs;
  inherit (lib.lists) singleton;
in {
  nixpkgs = {
    config = {
      allowAliases = false;
      allowUnfree = true;

      permittedInsecurePackages = ["radicle-node-1.10.3"];
    };

    overlays = [
      kaktu5pkgs
    ];
  };

  assertions = singleton {
    assertion = pkgs.radicle-node.version == "1.10.3";
    message = "remove radicle-node-1.10.3 from permittedInsecurePackages";
  };
}
