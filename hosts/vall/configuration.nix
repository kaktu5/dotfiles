{config, ...}: let
  inherit (config.kkts.meta) userName;
  inherit (config.networking) hostName;
in {
  security.nix-secrets.recipientAliases.${hostName} = "age1hpw9kjwzsa92cr4573z72766srf2pk3t72ycdpd2n5ph7a4dh3zqfpmg80";

  users.users.${userName}.initialPassword = "nix";

  system.stateVersion = "26.11";
}
