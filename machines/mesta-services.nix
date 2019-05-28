{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/libvirt.nix
  ];
  networking.nat = {
     forwardPorts = [ ];
  };

  virtualisation.docker.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;

  services.httpd = {
    enable = true;
    enablePHP = true;
    listen = [{ ip = "127.0.0.1"; port = 8000; }];

    phpOptions = ''
      extension=${pkgs.phpPackages.apcu}/lib/php/extensions/apcu.so
      zend_extension = opcache.so
      opcache.enable = 1
    '';

    adminAddr = "webmaster@otevrenamesta.cz";
    documentRoot = "/var/www";

    virtualHosts = [
      {
        hostName = "booked.otevrenamesta.cz";
        documentRoot = "/var/www/html";
        listen = [{ ip = "127.0.0.1"; port = 8001; }];
        extraConfig = ''
          <Directory /var/www/html>
            DirectoryIndex index.php
          </Directory>
        '';
      }
      {
        hostName = "glpi.otevrenamesta.cz";
        documentRoot = "/var/www/glpi";
        listen = [{ ip = "127.0.0.1"; port = 8002; }];
        extraConfig = ''
          <Directory /var/www/glpi>
            DirectoryIndex index.php
          </Directory>
        '';
      }
    ];
  };

  services.nginx = {
    enable = true;
    clientMaxBodySize = "2G";
    recommendedProxySettings = true;

    virtualHosts = {
      "booked.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8001";
          };
        };
      };
      "glpi.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:8002";
          };
        };
      };
      "forum.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://unix:/var/discourse/shared/standalone/nginx.http.sock:";
          };
        };
      };
    };
  };
}
