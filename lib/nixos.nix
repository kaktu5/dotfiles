{lib}: let
  inherit (lib) nixosSystem;
  inherit (lib.asserts) assertOneOf;
  inherit (lib.attrsets) attrNames listToAttrs mapAttrs nameValuePair;
  inherit (lib.fixedPoints) fix;
  inherit (lib.kkts.modules) modulesFromDirectoryRecursive;
  inherit (lib.lists) all concatLists concatMap map singleton;

  modulesPath = ../modules;

  coreModules = modulesFromDirectoryRecursive (modulesPath + /core);
  optionModules = modulesFromDirectoryRecursive (modulesPath + /options);
  profileModules = modulesFromDirectoryRecursive (modulesPath + /profiles);

  modulesByRole = let
    path = modulesPath + /roles;
    roles = ["graphical" "headless" "iso" "laptop" "microvm" "server" "workstation"];
  in
    roles
    |> map (role: nameValuePair role (modulesFromDirectoryRecursive (path + /${role})))
    |> listToAttrs;
in
  fix (self: {
    mkSystem = {
      hostName,
      system,
      roles ? [],
      extraModules ? [],
      specialArgs ? {},
    }:
      assert (roles |> all (role: assertOneOf "role" role (attrNames modulesByRole))); let
        hostModules = modulesFromDirectoryRecursive ../hosts/${hostName};
        roleModules = roles |> concatMap (role: modulesByRole.${role});
      in
        nixosSystem {
          inherit system specialArgs;
          modules = concatLists [
            (singleton {
              networking = {inherit hostName;};
              nixpkgs.hostPlatform = {inherit system;};
            })
            hostModules
            coreModules
            optionModules
            profileModules
            roleModules
            extraModules
          ];
        };

    mkSystemsFromAttrs = sharedAttrs: hostsAttrs: (hostsAttrs
      |> mapAttrs (hostName: hostAttrs:
        self.mkSystem (hostAttrs // {inherit hostName;} // sharedAttrs)));
  })
