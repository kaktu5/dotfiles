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

  modulesForTrait = let
    traitsPath = /${modulesPath}/traits;
    traits = ["bare-metal" "graphical" "headless" "iso" "laptop" "microvm" "server" "workstation"];
  in
    genAttrs traits (trait: modulesFromDirRec /${traitsPath}/${trait});

  modulesFor = {
    hostName,
    arch,
    traits,
    microvms ? {},
  }:
    (singleton {
      networking = {inherit hostName;};
      nixpkgs.hostPlatform.system = "${arch}-linux";
    })
    ++ modulesFromDirRec /${hostsPath}/${hostName}
    ++ commonModules
    ++ concatMap (trait: modulesForTrait.${trait}) traits
    ++ optional (microvms != {}) {
      microvm.vms =
        microvms
        |> mapAttrs (hostName: {
          arch,
          traits ? [],
        }: {
          inherit specialArgs;
          config.imports = modulesFor {inherit hostName arch traits;};
        });
    };
in {
  mkHosts = f:
    fix f
    |> mapAttrs (hostName: {
      arch,
      traits ? [],
      microvms ? {},
    }:
      nixosSystem {
        inherit specialArgs;
        modules = modulesFor {inherit hostName arch traits microvms;};
      });
}
