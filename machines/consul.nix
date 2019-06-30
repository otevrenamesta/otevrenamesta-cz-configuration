{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
  ];

  networking = {
     #firewall.allowedTCPPorts = [ 80 443 ];

     domain = "otevrenamesta.cz";
     hostName =  "consul";

  };

}
