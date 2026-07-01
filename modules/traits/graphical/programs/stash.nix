{
  services.stash-clipboard = {
    enable = true;

    serviceArguments = ["--persist"];
  };

  systemd.user.services.stash-clipboard.serviceConfig.Slice = "background.slice";
}
