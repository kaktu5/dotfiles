{lib}: let
  inherit (lib.attrsets) recursiveUpdate;
  inherit (lib.lists) all;
  inherit (lib.strings) match removePrefix replaceStrings stringToCharacters;
in {
  escapePath = path: suffix:
    assert all (c: match "[a-zA-Z0-9/_.-]" c != null) (stringToCharacters path);
      (path
        |> removePrefix "/"
        |> replaceStrings ["/" "-" "."] ["-" "\\x2d" "\\x2e"])
      + ".${suffix}";

  mkGraphicalTargetService = {
    after ? [],
    partOf ? [],
    wantedBy ? [],
    ...
  } @ attrs:
    attrs
    |> (a: removeAttrs a ["after" "partOf" "wantedBy"])
    |> recursiveUpdate {
      after = ["graphical-session.target"] ++ after;
      partOf = ["graphical-session.target"] ++ partOf;
      wantedBy = ["graphical-session.target"] ++ wantedBy;

      serviceConfig.Restart = "on-failure";
    };
}
