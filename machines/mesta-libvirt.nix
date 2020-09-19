{ config, lib, pkgs, ... }:
let
  brDev = config.virtualisation.libvirtd.networking.bridgeName;
  statusIp = "83.167.228.98";
  statusPorts = "9100,9113,9154,7980";
in
{
  imports = [
    ../modules/libvirt.nix
    ../modules/deploy.nix
  ];

  # restrict connections to prometheus exporters to status.otevrenamesta.cz only
  networking.firewall.extraCommands = ''
    iptables -I FORWARD -o ${brDev} -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP
    iptables -I INPUT -i lo -j ACCEPT
    iptables -I INPUT -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP
  '';
  networking.firewall.extraStopCommands = ''
    iptables -D FORWARD -o ${brDev} -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP || true
    iptables -D INPUT -i lo -j ACCEPT || true
    iptables -D INPUT -p tcp -m multiport --dports ${statusPorts} ! -s ${statusIp} -j DROP || true
  '';

  virtualisation.libvirtd = {
    enable = true;
    networking = {
      enable = true;
      infiniteLeaseTime = true;
      ipv6 = {
        network = "fda7:1646:3af8:666e::/64";
        hostAddress = "fda7:1646:3af8:666e::1";
        forwardPorts = [
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe27:cbe]:22";  sourcePort = 22; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe27:cbe]:80";  sourcePort = 80; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe27:cbe]:443"; sourcePort = 443; }

          { destination = "[fda7:1646:3af8:666e:5054:ff:fe6b:6c86]:25"; sourcePort = 25; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe6b:6c86]:143"; sourcePort = 143; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe6b:6c86]:587"; sourcePort = 587; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe6b:6c86]:993"; sourcePort = 993; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe6b:6c86]:4190"; sourcePort = 4190; }
          { destination = "[fda7:1646:3af8:666e:5054:ff:fe6b:6c86]:12340"; sourcePort = 12340; }
        ];
      };
    };
  };

  networking.nat = {
     forwardPorts = [
       { destination = "192.168.122.100:22";    sourcePort = 10022;} # mail ssh
       { destination = "192.168.122.100:25";    sourcePort = 25;}    # mail SMTP
       { destination = "192.168.122.100:143";   sourcePort = 143;}   # mail IMAP
       { destination = "192.168.122.100:587";   sourcePort = 587;}   # mail email message submission
       { destination = "192.168.122.100:993";   sourcePort = 993;}   # mail IMAPS, SSL
       { destination = "192.168.122.100:4190";  sourcePort = 4190;}  # mail dovecot
       { destination = "192.168.122.100:12340"; sourcePort = 12340;} # mail dovecot
       { destination = "192.168.122.100:9100";  sourcePort = 10091;} # mail prometheus node collector
       { destination = "192.168.122.100:9154";  sourcePort = 10094;} # mail prometheus postfix collector
       { destination = "192.168.122.100:7980";  sourcePort = 10098;} # mail prometheus rspamd collector

       { destination = "192.168.122.101:22"; sourcePort = 10122;}    # sympa ssh
       #{ destination = "192.168.122.101:80"; sourcePort = 10180;}    # sympa web # proxy accesses this host directly via br0
       { destination = "192.168.122.101:9100";  sourcePort = 10191;} # sympa prometheus node collector

       { destination = "192.168.122.102:22"; sourcePort = 10222;}    # midpoint ssh
       #{ destination = "192.168.122.102:8080"; sourcePort = 10280;}  # midpoint web # proxy accesses this host directly via br0

       { destination = "192.168.122.103:22"; sourcePort = 10322;}    # matomo ssh
       #{ destination = "192.168.122.103:80"; sourcePort = 10380;}    # matomo web # proxy accesses this host directly via br0
       { destination = "192.168.122.103:9100";  sourcePort = 10391;} # matomo prometheus node collector

       { destination = "192.168.122.104:22";  sourcePort = 10422;}   # proxy ssh
       { destination = "192.168.122.104:80";  sourcePort = 80;}      # proxy web
       { destination = "192.168.122.104:443"; sourcePort = 443;}     # proxy ssl
       { destination = "192.168.122.104:9100";  sourcePort = 10491;} # proxy prometheus node collector
       { destination = "192.168.122.104:9113";  sourcePort = 10493;} # proxy prometheus nginx collector

       { destination = "192.168.122.105:22";  sourcePort = 10522;}   # mediawiki ssh
       #{ destination = "192.168.122.105:80";  sourcePort = 10580;}   # mediawiki web
       { destination = "192.168.122.105:9100";  sourcePort = 10591;} # mediawiki prometheus node collector
     ];
  };

  #boot.enableContainers = true;

  # BAD!
  #networking.bridges.brct.interfaces = [ "venet0" ];
  #networking.interfaces.brct.ipv6.addresses = [
  #     { address = "2a03:3b40:fe:3d:8000::"; prefixLength = 65; }
  #   ];

  #containers.test = {
  #  privateNetwork = true;
  #  #hostBridge = "brct";
  #  localAddress6 = "2a03:3b40:fe:3d:8000::1/65";
  #  config = 
  #    { config, pkgs, ... }:
  #    {
  #      networking.firewall.allowedTCPPorts = [ 80 ];
  #      services.nginx.enable = true;
  #    };
  #};
}
