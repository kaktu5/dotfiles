{
  boot.kernelParams = ["systemd.machine_id=firmware"];

  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
}
