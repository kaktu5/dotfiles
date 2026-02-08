{lib}: let
  inherit (builtins) readDir;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) concatLists;
  inherit (lib.strings) hasSuffix;
  inherit (lib.trivial) pathExists;

  self = lib.kkts.modules;
in {
  modulesFromDirRec = dir: let
    defaultPath = dir + /module.nix;
    processDir = dir:
      readDir dir
      |> mapAttrsToList (name: type: let
        path = dir + /${name};
      in
        if type == "directory"
        then self.modulesFromDirRec path
        else if type == "regular" && hasSuffix ".nix" name
        then [path]
        else [])
      |> concatLists;
  in
    if pathExists defaultPath
    then [defaultPath]
    else processDir dir;
}
