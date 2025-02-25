{lib}: let
  inherit (builtins) attrNames filter map match readDir;
  inherit (lib) extend findFirst genAttrs pipe;
  inherit (lib.options) mkOption;
  inherit (lib.strings) hasPrefix;
  inherit (lib.types) attrsOf submodule;
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

        options.mkSubmodule = options: (mkOption {
          type = attrsOf (submodule {inherit options;} // {default = {};});
        });

        match = arms: expr:
          pipe arms [
            (map (arm: arm.${toString expr} or null))
            (findFirst (x: x != null) null)
          ];

        importAll = path:
          pipe path [
            readDir
            attrNames
            (filter (file:
              match file
              != null
              && !(hasPrefix "_" file)
              && file != "default.nix"))
            (map (file: path + "/${file}"))
          ];

        writeToml = pkgs: name: str: (pkgs.formats.toml {}).generate name str;

        /*
        writeNu = pkgs: filename: {
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
