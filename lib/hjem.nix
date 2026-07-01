{lib}: let
  inherit (lib.attrsets) concatMapAttrs listToAttrs nameValuePair;
in {
  toMimeMap = appToMimes:
    appToMimes
    |> concatMapAttrs (app: mimes:
      mimes
      |> map (mime: nameValuePair mime app)
      |> listToAttrs);
}
