{
  inputs,
  lib,
  ...
}: let
  inherit (inputs) ncro;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkForce;

  listen = "[::1]:5151";
in {
  imports = [ncro.nixosModules.default];

  persistence.directories = singleton {
    target = "/var/lib/private/ncro";
    mode = "700";
  };

  services.ncro = {
    enable = true;

    settings = {
      server = {inherit listen;};

      upstreams = [
        {
          url = "https://cache.nixos.org";
          public_key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
          priority = 10;
        }

        {
          url = "https://cache.forall.systems";
          public_key = "cache.forall.systems:5PmD7QO4MSF8YgyRZtkSGXRDo96H3bybIf2SsQh8ScI=";
          priority = 20;
        }
        {
          url = "https://cache.manic.systems";
          public_key = "cache.manic.systems-1:s6OZanN8Us8vRi0jVivP3qlMn0cYHBjBALKrNe5nH8s=";
          priority = 21;
        }
        {
          url = "https://nix-community.cachix.org";
          public_key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          priority = 22;
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
