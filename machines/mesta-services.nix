{ config, lib, pkgs, ... }:
let
  brDev = config.virtualisation.libvirtd.networking.bridgeName;
  proxyIp = "37.205.14.17";
  proxyPorts = "80,8000,8001,8002,8008,8080";
  statusIp = "83.167.228.98";
  statusPorts = "9100,9187,9113";
in
{
  imports = [
    ../modules/libvirt.nix
  ];

  environment.systemPackages = with pkgs; [
     nmap
  ];

  virtualisation.libvirtd = {
    enable = true;
    networking = {
      enable = true;
      infiniteLeaseTime = true;
      ipv6 = {
        network = "fda7:1646:3af8:666d::/64";
        hostAddress = "fda7:1646:3af8:666d::1";
        forwardPorts = [
          #{ destination = "[fda7:1646:3af8:666d:5054:ff:fe27:cbe]:22";  sourcePort = 22; }
          #{ destination = "[fda7:1646:3af8:666d:5054:ff:fe27:cbe]:80";  sourcePort = 80; }
          #{ destination = "[fda7:1646:3af8:666d:5054:ff:fe27:cbe]:443"; sourcePort = 443; }
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  # restrict incoming connections to proxy.otevrenamesta.cz only
  # to prevent X-Real-Ip: etc header spoofing
  # also restrict connections to prometheus exporters to status.otevrenamesta.cz only
  networking.firewall.extraCommands = ''
    iptables -I FORWARD -o ${brDev} -p tcp -m multiport --dports ${proxyPorts} ! -s ${proxyIp} -j DROP
    iptables -I FORWARD -o ${brDev} -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP
    iptables -I INPUT -i lo -j ACCEPT
    iptables -I INPUT -p tcp -m multiport --dports ${proxyPorts} ! -s ${proxyIp} -j DROP
    iptables -I INPUT -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D FORWARD -o ${brDev} -p tcp -m multiport --dports ${proxyPorts} ! -s ${proxyIp} -j DROP || true
    iptables -D FORWARD -o ${brDev} -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP || true
    iptables -D INPUT -i lo -j ACCEPT || true
    iptables -D INPUT -p tcp -m multiport --dports ${proxyPorts} ! -s ${proxyIp} -j DROP || true
    iptables -D INPUT -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP || true
  '';

  networking.nat = {
    forwardPorts = [
      { destination = "192.168.122.102:22"; sourcePort = 10222;}    # consul ssh
      { destination = "192.168.122.103:22"; sourcePort = 10322;}    # roundcube ssh
      { destination = "192.168.122.104:22"; sourcePort = 10422;}    # glpi ssh
      { destination = "192.168.122.105:22"; sourcePort = 10522;}    # wp ssh
      { destination = "192.168.122.107:22"; sourcePort = 10722;}    # nia ssh
      { destination = "192.168.122.108:22"; sourcePort = 10822;}    # ucto ssh
      { destination = "192.168.122.109:22"; sourcePort = 10922;}    # matrix ssh
      { destination = "192.168.122.111:22"; sourcePort = 11122;}    # dsw-test ssh

      { destination = "192.168.122.103:80"; sourcePort = 10380;}    # roundcube http
      { destination = "192.168.122.104:80"; sourcePort = 10480;}    # glpi http
      { destination = "192.168.122.105:80"; sourcePort = 10580;}    # wp http
      { destination = "192.168.122.107:80"; sourcePort = 10780;}    # nia http
      { destination = "192.168.122.108:80"; sourcePort = 10880;}    # ucto http
      { destination = "192.168.122.109:80"; sourcePort = 10980;}    # matrix http (riot)
      { destination = "192.168.122.111:80"; sourcePort = 11180;}    # dsw-test http

      { destination = "192.168.122.104:9100"; sourcePort = 10491;}  # glpi prometheus node exporter
      { destination = "192.168.122.105:9100"; sourcePort = 10591;}  # wp prometheus node exporter
      { destination = "192.168.122.107:9100"; sourcePort = 10791;}  # nia prometheus node exporter
      { destination = "192.168.122.109:9100"; sourcePort = 10991;}  # matrix prometheus node exporter
      { destination = "192.168.122.109:9187"; sourcePort = 10997;}  # matrix prometheus postgresql exporter
      { destination = "192.168.122.109:9113"; sourcePort = 10993;}  # matrix prometheus nginx exporter

      { destination = "192.168.122.109:8448"; sourcePort = 10984;}  # matrix synapse (clients+federation)
    ];
  };

  virtualisation.docker.enable = true;

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;
  services.mysqlBackup = {
    enable = true;
    databases = [ "glpi" "bookedscheduler" ];
  };

  services.httpd = {
    enable = true;
    enablePHP = true;

    phpOptions = ''
      extension=${pkgs.php.extensions.apcu}/lib/php/extensions/apcu.so
      zend_extension = opcache.so
      opcache.enable = 1
    '';

    adminAddr = "webmaster@otevrenamesta.cz";

    virtualHosts = {
      "booked.otevrenamesta.cz" = {
        documentRoot = "/var/www/html";
        listen = [{ ip = "127.0.0.1"; port = 8001; }];
        extraConfig = ''
          <Directory /var/www/html>
            DirectoryIndex index.php
          </Directory>
        '';
      };
    };
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
      "forum.vesp.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://unix:/var/discourse/shared/standalone/nginx.http.sock:";
            extraConfig = ''
              proxy_set_header X-Forwarded-Proto https;
            '';
          };
        };
      };
    };
  };
}
