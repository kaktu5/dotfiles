{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.hjem.users.${userName}) xdg;
  inherit (config.kkts.meta) userName;
  inherit (config.kkts.profiles) gaming;
  inherit (config.users.users.${userName}) uid;
  inherit (lib.modules) mkIf;
  inherit (pkgs) prismlauncher;
in
  mkIf (gaming.enable && gaming.minecraft.enable) {
    # /tmp is noexec, but minecraft needs to exec native libs from its tmpdir,
    # so java.io.tmpdir needs to point here instead
    fileSystems."${xdg.data.directory}/PrismLauncher/tmp" = {
      device = "none";
      fsType = "tmpfs";
      options = ["X-mount.mkdir" "exec" "mode=700" "size=64M" "uid=${uid}"];
    };

    persistence.users.${userName}.directories = [".local/share/PrismLauncher"];

    users.users.${userName}.packages = [prismlauncher];
  }
