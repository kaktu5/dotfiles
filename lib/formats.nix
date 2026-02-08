{lib}: let
  inherit (lib.attrsets) attrNames isAttrs isDerivation mapAttrsToList;
  inherit (lib.lists) elem filter subtractLists toList;
  inherit (lib.strings) concatMapStringsSep concatStringsSep typeOf;
  inherit (lib.trivial) boolToString;

  typeOf' = v:
    if v == null
    then "null"
    else if isDerivation v
    then "derivation"
    else typeOf v;
in {
  hyprlang.generate = {priorityKeys ? []}: attrs: let
    orderKeys = keys: let
      priorityKeys' = priorityKeys |> filter (key: elem key keys);
      restKeys = subtractLists priorityKeys' keys;
    in
      priorityKeys' ++ restKeys;

    mkValue = v: let
      cases = {
        bool = boolToString v;
        float = toString v;
        int = "${v}";
        list = concatMapStringsSep "," mkValue v;
        null = "";
      };
    in
      cases.${typeOf' v} or (toString v);

    mkCategory = attrs:
      attrs
      |> attrNames
      |> orderKeys
      |> map (key:
        attrs.${key}
        |> toList
        |> concatMapStringsSep "\n" (v:
          if isAttrs v && !isDerivation v
          then "${key}{\n${mkCategory v}\n}"
          else "${key}=${mkValue v}"))
      |> concatStringsSep "\n";
  in
    mkCategory attrs;

  nuon = {
    closure = args: body: {
      _type = "closure";
      inherit args body;
    };

    generate = {}: attrs: let
      mkValue = v:
        if isAttrs v && v._type or "" == "closure"
        then "{|${concatStringsSep "," v.args}|${v.body}}"
        else let
          cases = {
            bool = boolToString v;
            float = toString v;
            int = "${v}";
            list = "[${concatMapStringsSep "," mkValue v}]";
            null = "null";
            set = mkRecord v;
          };
        in
          cases.${typeOf' v} or "\"${toString v}\"";

      mkRecord = attrs: "{${
        attrs
        |> mapAttrsToList (k: v: "${k}:${mkValue v}")
        |> concatStringsSep ","
      }}";
    in
      mkRecord attrs;
  };
}
