{lib}: let
  inherit (lib.attrsets) isDerivation mapAttrsToList;
  inherit (lib.lists) foldl';
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
