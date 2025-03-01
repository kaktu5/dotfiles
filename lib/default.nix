{
  lib,
  pkgs,
}: let
  inherit (builtins) attrNames filter map match readDir toString;
  inherit
    (lib)
    concatStrings
    concatStringsSep
    extend
    findFirst
    genAttrs
    getExe
    hasPrefix
    makeBinPath
    mkOption
    pipe
    ;
  inherit (lib.types) attrsOf submodule;
  inherit (pkgs) makeWrapper symlinkJoin writeScriptBin;
  inherit (pkgs.formats) toml;
in
  extend (
    _: _: {
      kkts = {
        forEachSystem = genAttrs ["x86_64-linux" "aarch64-linux"];

        ###
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

        match = expr: arms:
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

        writeToml = name: str: (toml {}).generate name str;

        mkWrapper = name: paths: args:
          symlinkJoin {
            inherit name paths;
            nativeBuildInputs = [makeWrapper];
            postBuild = ''
              wrapProgram $out/bin/${name} ${concatStringsSep " " args}
            '';
          };

        writeNu = filename: {
          package ? pkgs.nushell,
          path ? [],
          plugins ? [],
        }: script: (writeScriptBin filename (concatStrings [
          ''
            #!${getExe package}
            $env.PATH = "${makeBinPath ([pkgs.coreutils] ++ path)}"${"\n"}
          ''
          (concatStringsSep "\n"
            (map (plugin: "plugin add ${getExe plugin}") plugins))
          script
        ]));
      };
    }
  )
