{lib, ...}: let
  inherit (lib.trivial) importJSON;
in
  (importJSON ./layout.json)
  // {
    zramSwap.memoryMax = 8 * 1024 * 1024 * 1024;
  }
