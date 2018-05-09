{
  proxy =
    { config, lib, pkgs, ... }:
    { 
      imports = [
        ../build-vpsfree-templates/files/configuration.nix
      ];

      deployment.targetHost = "185.8.164.67";

      #netboot.host = "sproxy.otevrenamesta.cz";
      #netboot.acmeSSL = true;

      #web.acmeSSL = true;
    };
} 
