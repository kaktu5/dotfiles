{lib, ...}: let
  inherit (lib.trivial) importJSON;
in
  (importJSON ./layout.json)
  // {
    zramSwap.memoryMax = 16 * 1024 * 1024 * 1024;
  }
