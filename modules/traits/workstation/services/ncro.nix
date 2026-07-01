{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) ncro;
  inherit (lib.modules) mkForce;

  listen = "[::1]:5151";
in {
  imports = [ncro.nixosModules.default];

  persistence.directories = ["/var/lib/ncro"];

  services.ncro = {
    enable = true;

    settings = {
      server = {inherit listen;};

      upstreams = [
        {
          url = "https://cache.nixos.org";
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          priority = 0;
        }
        {
          url = "https://cache.manic.systems";
          public_key = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
          priority = 1;
        }
      ];

      logging = {
        level = "warn";
        timestamps = false;
      };
    };
  };

  nix.settings.substituters = mkForce ["http://${listen}"];
}
