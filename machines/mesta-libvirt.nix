{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/libvirt.nix
    ../modules/deploy.nix
  ];

  virtualisation.libvirtd = {
    enable = true;
    networking = {
      enable = true;
      infiniteLeaseTime = true;
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

       { destination = "192.168.122.101:22"; sourcePort = 10122;}    # sympa ssh
       { destination = "192.168.122.101:80"; sourcePort = 10180;}    # sympa web

       { destination = "192.168.122.102:22"; sourcePort = 10222;}    # midpoint ssh
       { destination = "192.168.122.102:8080"; sourcePort = 10280;}  # midpoint web

       { destination = "192.168.122.103:22"; sourcePort = 10322;}    # matomo ssh
       { destination = "192.168.122.103:80"; sourcePort = 10380;}    # matomo web

       { destination = "192.168.122.104:22";  sourcePort = 10422;}   # proxy ssh
       { destination = "192.168.122.104:80";  sourcePort = 80;}      # proxy web
       { destination = "192.168.122.104:443"; sourcePort = 443;}     # proxy ssl
     ];
  };
}
