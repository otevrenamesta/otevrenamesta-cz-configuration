{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 443 ];

     domain = "otevrenamesta.cz";
     hostName =  "navstevnost";

     hosts = {
       "127.0.0.1" = [ "matomo.navstevnost.otevrenamesta.cz" ];
     };
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

  services.geoip-updater.enable = true; # downloads GeoIP dbs to /var/lib/geoip-databases
}
