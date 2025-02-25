{
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues concatLists concatMap customClosure;
  inherit (lib) forEach pipe;
in {
  system.extraDependencies = pipe inputs [
    attrValues
    (concatMap (input:
      customClosure [input] (x: let
        inputs = attrValues (x.inputs or {});
      in
        forEach inputs (input': {key = input';}))))
    concatLists
  ];
}
