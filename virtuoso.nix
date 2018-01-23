{ config, pkgs, ... }:

{
  services.virtuoso = {
    enable = true;
    httpListenAddress = "virtuoso:8890";
    #dirsAllowed = "/www, /home/";
  };
}


