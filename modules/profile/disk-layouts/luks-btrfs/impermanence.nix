{
  config,
  lib,
  ...
}: let
  inherit (builtins) replaceStrings stringLength substring;
  inherit (lib) pipe;
  cfg = config.kkts.hardware.rootFileSystem;
  inherit (cfg) root;
  root' = pipe root [
    (substring 1 (stringLength root))
    (replaceStrings ["-" "/"] [''\x2d'' "-"])
    (str: (str + ".device"))
  ];
in {
  boot.initrd.systemd.services.impermanence = {
    wantedBy = ["initrd.target"];
    requires = [root'];
    before = ["sysroot.mount"];
    after = [root'];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir /impermanence
      mount ${root} "/impermanence"
      if [[ -e "/impermanence/root" ]]; then
        mkdir -p "/impermanence/old_roots"
        timestamp=$(date --date "$(stat -c %y "/impermanence/root")" "+%s")
        mv "/impermanence/root" "/impermanence/old_roots/$timestamp"
      fi
      btrfs subvolume create "/impermanence/root"
      umount "/impermanence"
    '';
  };
}
