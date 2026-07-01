{lib}: let
  inherit (lib.attrsets) filterAttrs mapAttrs zipAttrsWith;
  inherit (lib.lists) elem foldl';
in {
  mapSystems = systems: f:
    systems
    |> map (s: f s |> mapAttrs (_: v: {${s} = v;}))
    |> zipAttrsWith (_: foldl' (a: b: a // b) {});

  selectSystem = system: outputs: inputs:
    inputs
    |> mapAttrs (_: input:
      if (input._type or null) == "flake"
      then
        input
        |> filterAttrs (k: _: elem k outputs)
        |> mapAttrs (_: v: v.${system})
        |> (o: input // o)
      else input);
}
