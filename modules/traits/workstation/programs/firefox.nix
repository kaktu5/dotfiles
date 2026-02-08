{
  config,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (pkgs) firefox;
in {
  preservation.preserveAt."/persist".users.${userName}.directories = [".config/mozilla/firefox"];

  users.users.${userName}.packages = [firefox];
}
