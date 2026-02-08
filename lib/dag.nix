# based on https://github.com/nix-community/home-manager/blob/27b93804fbef1544cb07718d3f0a451f4c4cd6c0/modules/lib/dag.nix
{lib}: let
  inherit (lib.attrsets) attrNames attrValues filterAttrs isAttrs mapAttrs;
  inherit (lib.lists) all elem filter toposort;
  inherit (lib.strings) concatMapStringsSep concatStringsSep removeSuffix;

  self = lib.kkts.dag;
in {
  isEntry = e: e ? data && e ? after && e ? before;
  isDag = dag: isAttrs dag && all self.isEntry <| attrValues dag;

  topoSort = dag: let
    after = n: dag |> filterAttrs (_: v: elem n v.before) |> attrNames;
    sorted =
      dag
      |> mapAttrs (name: value: {
        inherit name;
        inherit (value) data;
        after = value.after ++ after name;
      })
      |> attrValues
      |> toposort (a: b: elem a.name b.after);
  in
    if sorted ? result
    then {result = map (v: {inherit (v) name data;}) sorted.result;}
    else sorted;

  mapEntryData = f: mapAttrs (n: v: v // {data = f n v.data;});

  entryBetween = before: after: data: {inherit data before after;};
  entryAnywhere = self.entryBetween [] [];
  entryAfter = self.entryBetween [];
  entryBefore = b: self.entryBetween b [];

  resolveWith = f: dag: let
    sorted = self.topoSort dag;
  in
    if sorted ? result
    then map (e: f e.name e.data) sorted.result
    else throw "DAG cycle detected involving: ${sorted.cycle |> concatMapStringsSep ", " (e: e.name)}";

  resolveStr = dag:
    dag
    |> self.resolveWith (_: x: x)
    |> filter (s: s != "")
    |> map (removeSuffix "\n")
    |> concatStringsSep "\n\n";
}
