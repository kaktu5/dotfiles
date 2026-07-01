{
  inputs,
  self,
  systems,
}: let
  inherit (inputs) vaultix;
in
  vaultix.configure {
    nodes = self.nixosConfigurations;
    identity = "/run/vaultix/id";
    cache = ".vaultix";
    inherit systems;
  }
