{lib}: let
  inherit (builtins) isString;
  inherit (lib.attrsets) attrNames collect isAttrs isDerivation mapAttrsRecursive mapAttrsToList;
  inherit (lib.lists) elem filter subtractLists toList;
  inherit (lib.strings) concatMapStringsSep concatStringsSep escape replaceString typeOf;
  inherit (lib.trivial) boolToString;
  inherit (lib.generators) mkKeyValueDefault mkValueStringDefault toINI;

  typeOf' = v:
    if v == null
    then "null"
    else if isDerivation v
    then "derivation"
    else typeOf v;
in {
  toHyprlang = {priorityKeys ? []}: attrs: let
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

  toNuon = {}: attrs: let
    mkValue = v: let
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

  toQSettings = {}: let
    mkKeyValue = key: value:
      if isAttrs value
      then
        value
        |> mapAttrsRecursive (path: val: let
          key' = [key] ++ path |> concatStringsSep "\\" |> escape ["="];
          val' = val |> mkValueStringDefault {} |> replaceString "\n" "\\n";
        in "${key'}=${val'}")
        |> collect isString
        |> concatStringsSep "\n"
      else mkKeyValueDefault {} "=" key value;
  in
    toINI {inherit mkKeyValue;};
}
