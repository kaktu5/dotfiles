# TODO: move this to modules/traits/workstation/services/radicle-node
# TODO: keep radicle key in nix-secrets
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.kkts.meta) userName;
  inherit (config.users.users.${userName}) home;
  inherit (lib.generators) toJSON;
  inherit (lib.kkts.systemd) mkUserTargetService;
  inherit (pkgs) radicle-node;
in {
  persistence.users.${userName}.directories = [
    ".local/share/radicle/cobs"
    ".local/share/radicle/keys"
    ".local/share/radicle/node"
    ".local/share/radicle/storage"
  ];

  networking.firewall.allowedTCPPorts = [8776];

  users.users.${userName}.packages = [radicle-node];

  hjem.users.${userName} = {
    environment.sessionVariables.RAD_HOME = "${home}/.local/share/radicle";

    systemd.services.radicle-node = mkUserTargetService {
      serviceConfig = {
        Environment = "RAD_HOME=${home}/.local/share/radicle";
        ExecStart = "${radicle-node}/bin/radicle-node --log-logger systemd";
      };
    };

    xdg.data.files."radicle/config.json" = {
      generator = toJSON {};
      value = {
        preferredSeeds = [
          "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosa.radicle.network:8776"
          "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@iris.radicle.network:8776"
        ];

        cli.hints = false;

        node = {
          alias = "kaktu5";

          onion.mode = "drop";
          i2p.mode = "drop";

          relay = "never";
          fetch.signedReferences.featureLevel.minimum = "parent";
        };
      };
    };
  };
}
