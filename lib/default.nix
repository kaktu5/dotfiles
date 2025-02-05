{nixpkgs, ...}: let
  inherit (nixpkgs) lib;
  inherit (builtins) attrNames filter map match readDir;
  inherit (lib) genAttrs pipe;
in
  nixpkgs.lib.extend (
    _: _: {
      kkts = {
        forEachSystem = genAttrs ["x86_64-linux" "aarch64-linux"];

        modules.collect = path:
          pipe path [
            readDir
            attrNames
            (filter (file: match file != null && file != "default.nix"))
            (map (file: path + "/${file}"))
          ];
      };
    }
  )
