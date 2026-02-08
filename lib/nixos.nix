{
  inputs,
  lib,
  self,
}: let
  inherit (lib) nixosSystem;
  inherit (lib.attrsets) genAttrs mapAttrs;
  inherit (lib.fixedPoints) fix;
  inherit (lib.kkts.modules) modulesFromDirRec;
  inherit (lib.lists) concatMap optional singleton;

  specialArgs = {
    inherit inputs lib;
    flake = self;
  };

  hostsPath = ../hosts;
  modulesPath = ../modules;

  commonModules =
    modulesFromDirRec /${modulesPath}/core
    ++ modulesFromDirRec /${modulesPath}/options
    ++ modulesFromDirRec /${modulesPath}/profiles;

  modulesForRole = let
    rolesPath = /${modulesPath}/roles;
    roles = ["bare-metal" "graphical" "headless" "iso" "laptop" "microvm" "server" "workstation"];
  in
    genAttrs roles (role: modulesFromDirRec /${rolesPath}/${role});

  modulesFor = {
    hostName,
    arch,
    roles,
    microvms ? {},
  }:
    (singleton {
      networking = {inherit hostName;};
      nixpkgs.hostPlatform.system = "${arch}-linux";
    })
    ++ modulesFromDirRec /${hostsPath}/${hostName}
    ++ commonModules
    ++ concatMap (role: modulesForRole.${role}) roles
    ++ optional (microvms != {}) {
      microvm.vms =
        microvms
        |> mapAttrs (hostName: {
          arch,
          roles ? [],
        }: {
          inherit specialArgs;
          config.imports = modulesFor {inherit hostName arch roles;};
        });
    };
in {
  mkHosts = f:
    fix f
    |> mapAttrs (hostName: {
      arch,
      roles ? [],
      microvms ? {},
    }:
      nixosSystem {
        inherit specialArgs;
        modules = modulesFor {inherit hostName arch roles microvms;};
      });
}
