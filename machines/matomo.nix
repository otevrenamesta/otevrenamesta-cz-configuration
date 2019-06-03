{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 443 ];
  };

  services.matomo.enable = true;

  services.matomo.nginx = {
    forceSSL = false;
    enableACME = false;
    serverAliases = [ "navstevnost.otevrenamesta.cz" ];
  };

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;

  services.nginx.enable = true;
}
