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

  services.nginx.enable = true;
  services.matomo.enable = true;
  services.matomo.nginx = {
    forceSSL = false;
    enableACME = false;
    serverAliases = [ "navstevnost.otevrenamesta.cz" ];
  };

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;

  services.mysqlBackup = {
    enable = true;
    databases = [ "matomo" ];
  };

  # see also https://github.com/NixOS/nixpkgs/pull/55867
  services.geoip-updater.enable = true; # downloads GeoIP dbs to /var/lib/geoip-databases
  systemd.tmpfiles.rules = let f = "GeoLite2-City.mmdb"; in [
    "d /var/lib/matomo/misc      0770 matomo matomo - -"
    "L /var/lib/matomo/misc/${f} -    -      -      - ${config.services.geoip-updater.databaseDir}/${f}"
  ];
}
