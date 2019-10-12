{ config, pkgs, ... }:

{
  imports = [
    ../modules/midpoint.nix
  ];

  #environment.systemPackages = with pkgs; [ vim ];

  networking = {
     firewall.allowedTCPPorts = [ 8080 ];

     domain = "otevrenamesta.cz";
     hostName =  "midpoint";
  };

  documentation.enable = false;
  documentation.nixos.enable = false;

  services.midpoint.enable = true;
}
