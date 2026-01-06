{
  imports = [./kkts.nix ./root.nix];

  users = {
    mutableUsers = false;
    defaultUserShell = "/run/current-system/sw/bin/nologin";
  };
}
