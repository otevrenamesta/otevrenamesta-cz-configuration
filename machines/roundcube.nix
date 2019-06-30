{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "roundcube";

  };

  services.nginx.virtualHosts."webmail.otevrenamesta.cz" = {
    forceSSL = false;
    enableACME = false; 
  };
  
  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_9_6;

  services.roundcube = {
    enable = true;
    hostName = "webmail.otevrenamesta.cz";
    database.password = "wSjL9R8T9qRL";
  };
}
