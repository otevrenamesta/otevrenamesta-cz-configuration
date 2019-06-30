{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
     gcc
     gnumake
     perl528Packages.Appcpanminus
  ];

  networking = {
     #firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "lists";

  };

  #services.nginx.virtualHosts."webmail.otevrenamesta.cz" = {
  #  forceSSL = false;
  #  enableACME = false; 
  #};
  #
  #services.postgresql.enable = true;
  #services.postgresql.package = pkgs.postgresql_9_6;

  #services.roundcube = {
  #  enable = true;
  #  hostName = "webmail.otevrenamesta.cz";
  #  database.password = "wSjL9R8T9qRL";
  #};
}
