{
  lib,
  pkgs,
  theme,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib) singleton;
  inherit (lib.kkts) writeNu;
  inherit (theme) colors windowManager;
in {
  home.packages = singleton (writeNu "screenshot" {
      path = with pkgs; [
        grim
        hyprland
        slurp
        wl-clipboard
      ];
    }
    # nu
    ''
      const gaps: int = ${toString windowManager.gapsSize}

      let file: path = $"($nu.home-path)/pictures/screenshots/(
        date now | format date "%Y-%m-%d_%H-%M-%S").png"

      def resize_sel [sel: list<int>, size: int] {[
        ($sel.0 - $size)
        ($sel.1 - $size)
        ($sel.2 + 2 * $size)
        ($sel.3 + 2 * $size)
      ]}

      def main [mode: string] {
        match $mode {
          "screen" => (^grim $file),
          "window" => {
            let window: any = (^hyprctl activewindow -j | from json)
            let sel: list<int> = resize_sel ($window.at ++ $window.size) (2 * $gaps)
            ^grim -g $"($sel.0),($sel.1) ($sel.2)x($sel.3)" $file
          },
          "region" => {
            mut sel: list<int> = (^slurp
              -f "%x,%y,%w,%h"
              -w 2
              -b "#${colors.bg0}bb"
              -c "#${colors.fg3}ff"
              | split row ","
              | into int)
            $sel = resize_sel $sel -1
            ^grim -g $"($sel.0),($sel.1) ($sel.2)x($sel.3)" $file
          },
        }
        open -r $file | ^wl-copy -t image/png
      }
    '');
}
