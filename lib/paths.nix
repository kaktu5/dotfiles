{lib}: let
  inherit (lib.attrsets) mapAttrs;
  inherit (lib.lists) isList;
in {
  prefixEach = prefix: value:
    if isList value
    then value |> map (dir: "${prefix}/${dir}")
    else value |> mapAttrs (_: dir: "${prefix}/${dir}");
}
