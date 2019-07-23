{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ vim ];
  #environment.systemPackages = with pkgs; [ vim (let n = import ../../nixpkgs {}; in n.pgloader) ];

  networking = {
     firewall.allowedTCPPorts = [ 80 25 443 ];

     domain = "otevrenamesta.cz";
     hostName =  "lists";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "127.0.0.1";
    ensureDatabases = [ "sympa" ];
    ensureUsers = [
      {
        name = "sympa";
        ensurePermissions = {
          "sympa.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  documentation.enable = false;
  documentation.nixos.enable = false;
  #services.nginx.virtualHosts."lists.try.otevrenamesta.cz" = { default = true; };

  services.postfix = {
    enable = true;
    relayHost = "192.168.122.100"; # do NOT use [brackets] here
  };

  # workaround https reverse proxy
  services.nginx.virtualHosts."lists.otevrenamesta.cz".locations."/".extraConfig = ''
    fastcgi_param HTTPS on;
  '';

  services.sympa = {
    enable = true;
    lang = "cs";
    mainDomain = "lists.otevrenamesta.cz";
    domains = {
      "lists.otevrenamesta.cz" = {
        webHost = "lists.otevrenamesta.cz";
      };
    };
    listMasters = [ "martin@martinmilata.cz" "nesnera@email.cz" "ladislav.nesnera@liberix.cz" ];
    web = {
      enable = true;
      fcgiProcs = 2;
      https = false;
    };
    database = {
      type = "MySQL";
      host = "localhost";
      user = "sympa";
    };
#    database = {
#      type = "PostgreSQL";
#      host = "/run/postgresql";
#      user = "sympa";
#    };
    extraConfig = ''
      cookie 00000000000000000000000000000001
    '';
  };

#  services.postgresql = {
#    enable = true;
#    package = pkgs.postgresql_11;
#    authentication = "local all all trust";
#    initialScript = pkgs.writeText "postgresql-init" ''
#      CREATE ROLE sympa NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
#      CREATE DATABASE sympa OWNER sympa ENCODING 'UNICODE';
#    '';
#  };

}
