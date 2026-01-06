{
  boot.initrd = {
    compressorArgs = ["-T0" "-9"];

    systemd.enable = true;
  };
}
