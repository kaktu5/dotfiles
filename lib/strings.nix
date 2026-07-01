{lib}: let
  inherit (lib.attrsets) attrNames attrValues;
  inherit (lib.strings) readFile replaceStrings;
in {
  replaceVars = file: vars: let
    placeholders = vars |> attrNames |> map (name: "@${name}@");
    replacements = vars |> attrValues |> map toString;
  in
    file |> readFile |> replaceStrings placeholders replacements;
}
