{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) replaceStrings stringLength substring;
  inherit (lib) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool;
  toSystemdPath = path:
    (replaceStrings ["-" "/"] [''\x2d'' "-"]
      (substring 1 (stringLength path) path))
    + ".device";
  inherit (config.kkts.rootfs) root;
  cfg = config.kkts.impermanence;
in {
  imports = [inputs.impermanence.nixosModules.impermanence];
  options.kkts.impermanence = {
    enable = mkOption {type = bool;} // {default = true;};
  };
  config = mkIf cfg.enable {
    fileSystems = {
      "/persist".neededForBoot = true;
      "/mnt/root" = {device = root;};
    };
    boot.initrd.systemd.services.impermanence = {
      wantedBy = ["initrd.target"];
      requires = [(toSystemdPath root)];
      before = ["sysroot.mount"];
      after = [(toSystemdPath root)];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /root_tmp
        mount ${root} /root_tmp
        if [[ -e /root_tmp/root ]]; then
          mkdir -p /root_tmp/old_roots
          timestamp=$(date --date "$(stat -c %y /root_tmp/root)" "+%s")
          mv /root_tmp/root "/root_tmp/old_roots/$timestamp"
        fi
        btrfs subvolume create /root_tmp/root
        umount /root_tmp
      '';
    };
    environment.persistence."/persist/root" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/home" # tmp
      ];
      files = ["/etc/machine-id"];
    };
  };
}
