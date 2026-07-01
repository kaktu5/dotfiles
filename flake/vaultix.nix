{
  inputs,
  self,
  systems,
}: let
  inherit (inputs) vaultix;
in
  vaultix.configure {
    nodes = self.nixosConfigurations;
    identity = "/run/vaultix/kaktu5-key";
    cache = ".vaultix";
    inherit systems;
  }
