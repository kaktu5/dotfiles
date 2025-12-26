{lib}: let
  inherit (lib.lists) foldl';
  inherit (lib.strings) hasPrefix removePrefix splitString trim;
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
}
