{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "ucto";

  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ ln srk deploy jh ];

  services.nginx.enable = true;
  services.nginx.virtualHosts."ucto2.otevrenamesta.cz" = {
    forceSSL = false;
    enableACME = false; 
  };
  
  #services.postgresql.enable = true;
  #services.postgresql.package = pkgs.postgresql_9_6;

  #services.roundcube = {
  #  enable = true;
  #  hostName = "webmail.otevrenamesta.cz";
  #  database.password = "wSjL9R8T9qRL";
  #};
}
