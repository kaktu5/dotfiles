{lib}: let
  inherit (lib.lists) all;
  inherit (lib.strings) match removePrefix replaceStrings stringToCharacters;
in {
  escapePath = path: suffix:
    assert all (c: match "[a-zA-Z0-9/_.-]" c != null) (stringToCharacters path);
      (path
        |> removePrefix "/"
        |> replaceStrings ["/" "-" "."] ["-" "\\x2d" "\\x2e"])
      + ".${suffix}";
}
