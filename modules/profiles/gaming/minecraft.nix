{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf;
  inherit (lib.strings) concatStringsSep;
  inherit (pkgs) bubblewrap makeWrapper prismlauncher symlinkJoin;
in
  mkIf (gaming.enable && gaming.minecraft.enable) {
    persistence.users.${userName}.directories = [".local/share/PrismLauncher"];

    users.users.${userName}.packages = singleton (symlinkJoin {
      inherit (prismlauncher) name;
      paths = [prismlauncher];
      nativeBuildInputs = [makeWrapper];
      postBuild = ''
        rm $out/bin/prismlauncher
        makeWrapper ${getExe bubblewrap} $out/bin/prismlauncher \
          --add-flags '${concatStringsSep " " [
          "--dev-bind / /"
          "--tmpfs /tmp"
          "--setenv JAVA_TOOL_OPTIONS -Djna.tmpdir=/tmp"
          "--"
          (getExe prismlauncher)
        ]}'
      '';
    });
  }
