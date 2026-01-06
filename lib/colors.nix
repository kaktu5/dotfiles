{lib}: let
  inherit (lib.fixedPoints) fix;
  inherit (lib.lists) elemAt;
  inherit (lib.strings) concatStrings stringToCharacters;
  inherit (lib.trivial) mod;

  toHex = n: let
    digits = stringToCharacters "0123456789abcdef";
    high = elemAt digits (n / 16);
    low = elemAt digits (mod n 16);
  in
    high + low;
in
  fix (self: {
    rgb = r: g: b: {inherit r g b;};

    rgbToHex = {
      r,
      g,
      b,
    }:
      concatStrings [(toHex r) (toHex g) (toHex b)];

    rgbToHex' = rgb: "#" + self.rgbToHex rgb;
  })
