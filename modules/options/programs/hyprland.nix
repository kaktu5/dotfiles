{lib, ...}: let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.trivial) flip;
  inherit (lib.types) anything attrsOf listOf submodule;

  mkListOfAnythingOption = mkOption {
    type = listOf anything;
    default = [];
  };
in {
  options.kkts.programs.hyprland.settings = mkOption {
    type = submodule {
      freeformType = attrsOf anything;
      options = flip genAttrs (_: mkListOfAnythingOption) ["windowrule" "workspace"];
    };
    default = {};
  };
}
