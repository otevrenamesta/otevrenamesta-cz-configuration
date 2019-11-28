{ config, pkgs, ... }:

{
  imports = [ ./modules/etl.nix ];

  services.etl = {
    enable = true;
    domainURI = "http://lpetl";
  };
}

