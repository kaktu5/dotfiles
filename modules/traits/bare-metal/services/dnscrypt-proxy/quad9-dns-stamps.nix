{
  inputs,
  lib,
}: let
  inherit (inputs) dnscrypt-settings;
  inherit (lib.attrsets) listToAttrs nameValuePair;
  inherit (lib.lists) filter ifilter0 zipListsWith;
  inherit (lib.strings) hasPrefix readFile removePrefix splitString trim;
  inherit (lib.trivial) mod;

  parse = str: let
    lines =
      str
      |> splitString "\n"
      |> filter (l: hasPrefix "##" l || hasPrefix "sdns://" l);

    headers =
      lines
      |> ifilter0 (i: _: mod i 2 == 0)
      |> map (removePrefix "##")
      |> map trim;
    stamps =
      lines
      |> ifilter0 (i: _: mod i 2 == 1)
      |> map trim;
  in
    zipListsWith nameValuePair headers stamps |> listToAttrs;
in
  parse <| readFile "${dnscrypt-settings}/dnscrypt/quad9-resolvers-dnscrypt.md"
