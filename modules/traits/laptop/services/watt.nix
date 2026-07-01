{
  services.watt.enable = true;

  systemd.services.watt.environment.RUST_LOG = "warn";
}
