# based on https://github.com/notashelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/modules/core/common/system/nix/transcend/default.nix
{
  lib,
  modulesPath,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) singleton;

  modules.shadow = {
    owner = "kaktu5";
    repo = "nixpkgs";
    rev = "566ad15d1862bda6b90f0ebac8a7525d8c35c3e2";
    narHash = "sha256-6MnBYjS2MKisY3Dz9i7XzwnIunsx8g8hcdsf1qEJXB0=";
    module = "/programs/shadow.nix";
  };

  transcendModules =
    modules
    |> attrValues
    |> map ({
      owner,
      repo,
      rev,
      narHash,
      module,
    }: {
      disabledModules = [(modulesPath + module)];
      imports = singleton ((fetchTree {
          type = "github";
          inherit owner repo rev narHash;
        })
        + /nixos/modules/${module});
    });
in {
  imports = transcendModules;

  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
  };
}
