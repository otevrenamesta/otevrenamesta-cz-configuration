{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/libvirt.nix
  ];

  environment.systemPackages = with pkgs; [
     nmap
  ];

  networking.firewall.allowedTCPPorts = [ 80 3306];

  networking.nat = {
    forwardPorts = [
      { destination = "192.168.122.102:22"; sourcePort = 10222;}    # consul ssh
      { destination = "192.168.122.103:22"; sourcePort = 10322;}    # roundcube ssh
      { destination = "192.168.122.104:22"; sourcePort = 10422;}    # glpi ssh
      { destination = "192.168.122.105:22"; sourcePort = 10522;}    # wp ssh
      { destination = "192.168.122.106:22"; sourcePort = 10622;}    # ucto ssh
      { destination = "192.168.122.107:22"; sourcePort = 10722;}    # nia ssh
      { destination = "192.168.122.105:80"; sourcePort = 10580;}    # wp http # FIXME only allow connections from proxy
    ];
  };

  virtualisation.docker.enable = true;

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
            #proxyPass = "http://127.0.0.1:8002";
            proxyPass = "http://192.168.122.104";
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
      "nia.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://192.168.122.107";
          };
        };
      };
      "test.nia.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://192.168.122.107";
          };
        };
      };
      "ucto2.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://192.168.122.106";
          };
        };
      };
      "webmail.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://192.168.122.103";
          };
        };
      };
    };
  };
}
