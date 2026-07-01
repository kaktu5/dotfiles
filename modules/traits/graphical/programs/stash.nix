{
  services.stash-clipboard = {
    enable = true;

    arguments = ["--persist"];
  };

  systemd.user.services.stash-clipboard.serviceConfig.Slice = "background.slice";
}
