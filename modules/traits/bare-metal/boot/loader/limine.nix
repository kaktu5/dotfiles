{config, ...}: {
  boot.loader.limine = {
    enable = config.kkts.boot.loader == "limine";

    enableEditor = false;

    efiSupport = false;
  };
}
