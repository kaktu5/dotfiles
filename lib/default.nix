{nixpkgs, ...}: let
  inherit (nixpkgs) lib;
  inherit (builtins) attrNames filter map match readDir toString;
  inherit (lib) pipe;
in
  nixpkgs.lib.extend (
    _: _: {
      kkts = {
        forEachSystem = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];

        modules.collect = pipe ./. [
          readDir
          attrNames
          (filter (file: match file != null && file != "default.nix"))
          (map (file: toString ./. + "/${file}"))
        ];
      };
    }
  )
