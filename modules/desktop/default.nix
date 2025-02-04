{lib, ...}: let
  inherit (builtins) attrNames filter map match readDir toString;
  inherit (lib) pipe;
in {
  imports = pipe ./. [
    readDir
    attrNames
    (filter (file: match file != null && file != "default.nix"))
    (map (file: toString ./. + "/" + file))
  ];
}
