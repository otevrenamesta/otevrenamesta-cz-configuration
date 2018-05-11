{
  proxy =
    { config, lib, pkgs, ... }:
    { 
      imports = [
        ../build-vpsfree-templates/files/configuration.nix
      ];

      deployment.targetHost = "83.167.228.98";

      #netboot.host = "proxy.otevrenamesta.cz";
      #netboot.acmeSSL = true;

      #web.acmeSSL = true;
    };
} 
