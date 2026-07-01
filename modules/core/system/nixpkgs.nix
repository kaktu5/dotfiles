# based on https://github.com/notashelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/modules/core/common/system/nix/transcend/default.nix
{
  lib,
  modulesPath,
  ...
}: let
  inherit (lib.attrsets) attrValues;
  inherit (lib.lists) singleton;

  modules = {};

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
