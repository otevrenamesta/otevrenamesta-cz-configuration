{ config, lib, pkgs, ... }:
let
  brDev = config.virtualisation.libvirtd.networking.bridgeName;
  proxyIp = "37.205.14.17";
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
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 3306 ]; # FIXME really expose mysql to everyone?

# old proxy needs access for NIA
#  # restrict incoming connections to proxy.otevrenamesta.cz only
#  # to prevent X-Real-Ip: etc header spoofing
#  networking.firewall.extraCommands = ''
#    iptables -I FORWARD -o ${brDev} -p tcp -m multiport --dports 80,8080,8008 ! -s ${proxyIp} -j DROP
#    iptables -I INPUT -i lo -j ACCEPT
#    iptables -I INPUT -p tcp -m multiport --dports 80,8000,8001,8002 ! -s ${proxyIp} -j DROP
#  '';
#  networking.firewall.extraStopCommands = ''
#    iptables -D FORWARD -o ${brDev} -p tcp -m multiport --dports 80,8080,8008 ! -s ${proxyIp} -j DROP || true
#    iptables -D INPUT -i lo -j ACCEPT || true
#    iptables -D INPUT -p tcp -m multiport --dports 80,8000,8001,8002 ! -s ${proxyIp} -j DROP || true
#  '';

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
      { destination = "192.168.122.109:8008"; sourcePort = 10980;}  # matrix http
      { destination = "192.168.122.111:80"; sourcePort = 11180;}    # dsw-test http

      { destination = "192.168.122.109:8448"; sourcePort = 10984;}   # matrix synapse # FIXME client+federation ports can be shared
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
      #{
      #  hostName = "glpi.otevrenamesta.cz";
      #  documentRoot = "/var/www/glpi";
      #  listen = [{ ip = "127.0.0.1"; port = 8002; }];
      #  extraConfig = ''
      #    <Directory /var/www/glpi>
      #      DirectoryIndex index.php
      #    </Directory>
      #  '';
      #}
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
