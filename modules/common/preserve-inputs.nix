{inputs, ...}: let
  inherit (builtins) attrValues concatMap elem;
in {
  system.extraDependencies = let
    collectFlakeInputs = input: visited: let
      visitedInputs = visited ++ [input];
    in
      [input]
      ++ concatMap (input:
        if input ? inputs
        then
          if elem input visitedInputs
          then []
          else collectFlakeInputs input visitedInputs
        else []) (attrValues (input.inputs or {}));
  in
    concatMap (input: collectFlakeInputs input []) (attrValues inputs);
}
