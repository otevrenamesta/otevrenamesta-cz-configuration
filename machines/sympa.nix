{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
     gcc
     gnumake
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 25 443 ];

     domain = "otevrenamesta.cz";
     hostName =  "lists";

  };

  services.mysql = {
    enable = true;
    package = pkgs.mysql;
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

  #services.nginx.enable = true;
  documentation.enable = false;
  documentation.nixos.enable = false;
  services.nginx.virtualHosts."lists.try.otevrenamesta.cz" = { default = true; };

  services.postfix = {
    enable = true;
    relayHost = "192.168.122.100"; # do NOT use [brackets] here
  };

  services.sympa = {
    enable = true;
    mainDomain = "lists.try.otevrenamesta.cz";
    domains = {
      "lists.try.otevrenamesta.cz" = {
        webHost = "lists.try.otevrenamesta.cz";
      };
      ## disabled because we use aliases on try.otevrenamesta.cz instead
      #"try.otevrenamesta.cz" = {
      #  webHost = "mx.otevrenamesta.cz";
      #};
    };
    listMasters = [ "martin@martinmilata.cz" "nesnera@email.cz" "ladislav.nesnera@liberix.cz" ];
    web = {
      enable = true;
      fcgiProcs = 2;
    };
    database = {
      type = "MySQL";
      host = "localhost";
      user = "sympa";
      #name = "sympa";
    };
  };
}
