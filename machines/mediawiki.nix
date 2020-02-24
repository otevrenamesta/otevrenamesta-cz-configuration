{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  networking = {
     firewall.allowedTCPPorts = [ 22 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "wiki";
  };

  services.mediawiki = {
    enable = true;
    name = "Otevřená města";
    passwordFile = "/run/keys/mediawikiadmin";
    database = {
      type = "mysql";
      createLocally = true;
    };
    virtualHost = {
      hostName = "${config.networking.hostName}.${config.networking.domain}";
      adminAddr = "info@otevrenamesta.cz";
    };
  };

  services.mysql = {
    enable = true;
  };
  
}
