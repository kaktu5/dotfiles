{lib}: let
  inherit (builtins) attrNames filter map match readDir;
  inherit (lib) extend genAttrs pipe;
in
  extend (
    _: _: {
      kkts = {
        forEachSystem = genAttrs ["x86_64-linux" "aarch64-linux"];

        modules.collect = path:
          pipe path [
            readDir
            attrNames
            (filter (file: match file != null && file != "default.nix"))
            (map (file: path + "/${file}"))
          ];

        /*
        writers.writeNu = filename: {
          package ? pkgs.nushell,
          plugins ? [],
        }: script: (writeScriptBin filename (concatStringsSep "\n" [
          "#!${getExe package}"
          (concatStringsSep "\n"
            (map (plugin: "plugin add ${getExe plugin}") plugins))
          script
        ]));
        */
      };
    }
  )
