{lib}: let
  inherit (lib.attrsets) mapAttrs zipAttrsWith;
  inherit (lib.lists) foldl';
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
        // foldl' (acc: output:
          if input ? ${output}
          then acc // {${output} = input.${output}.${system};}
          else acc) {}
        outputs
      else input);
}
