{lib}: let
  inherit (lib.attrsets) attrNames isAttrs isDerivation mapAttrsToList;
  inherit (lib.lists) elem filter foldl' subtractLists toList;
  inherit (lib.strings) concatMapStringsSep concatStringsSep hasPrefix removePrefix splitString trim typeOf;
  inherit (lib.trivial) boolToString;

  typeOf' = v:
    if v == null
    then "null"
    else if isDerivation v
    then "derivation"
    else typeOf v;
in {
  dnsCryptStamps.parse = str: let
    isNameLine = hasPrefix "##";
    parseName = l: trim (removePrefix "##" l);
    isStampLine = hasPrefix "sdns://";
    parseStamp = trim;

    parseLine = acc: l:
      if isNameLine l
      then acc // {currentName = parseName l;}
      else if isStampLine l && acc.currentName != null
      then
        acc
        // {
          stamps = acc.stamps // {${acc.currentName} = parseStamp l;};
          currentName = null;
        }
      else acc;

    initialAcc = {
      stamps = {};
      currentName = null;
    };
  in
    (str |> splitString "\n" |> foldl' parseLine initialAcc).stamps;

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

  nuon.generate = {}: attrs: let
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
}
