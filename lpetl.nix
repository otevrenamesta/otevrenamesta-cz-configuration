{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    jdk9
    maven
    nodejs
  ];

  # XXX: finish this, needs package for https://github.com/linkedpipes/etl

}

