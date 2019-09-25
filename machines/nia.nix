{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     php
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "nia";

  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ deploy ln ms ];

  services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      bind = "127.0.0.1";
      #ensureDatabases = [ "sympa" ];
      #ensureUsers = [
      #  {
      #    name = "sympa";
      #    ensurePermissions = {
      #      "sympa.*" = "ALL PRIVILEGES";
      #    };
      #  }
      #];
    };

  services.nginx.enable = true;
  services.nginx.virtualHosts."nia.otevrenamesta.cz" = {
    forceSSL = false;
    enableACME = false; 
  };
  services.nginx.virtualHosts."test.nia.otevrenamesta.cz" = {
    forceSSL = false;
    enableACME = false; 
  };
  
  #services.postgresql.enable = true;
  #services.postgresql.package = pkgs.postgresql_9_6;

  #services.roundcube = {
  #  enable = true;
  #  hostName = "webmail.otevrenamesta.cz";
  #  database.password = "xxxx";
  #};
}
