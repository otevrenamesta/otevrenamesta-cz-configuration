{ config, lib, pkgs, ... }:
let
  home-manager-src = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/63f299b3347aea183fc5088e4d6c4a193b334a41.tar.gz";
    sha256 = "0iksjch94wfvyq0cgwv5wq52j0dc9cavm68wka3pahhdvjlxd3js";
  };
in
{
  imports = [
    "${home-manager-src}/nixos"
  ];

  environment.systemPackages = with pkgs; [
    morph
    screen
    git
    git-crypt
    gnupg pinentry
  ];

  home-manager.users.root = {
    home = {
      sessionVariables = {
        EDITOR = "vim";
      };
    };
    programs = {
      ssh = {
        enable = true;
        controlMaster = "auto";
        controlPersist = "1h";
        matchBlocks = {
          "consul" = {
            hostname = "37.205.14.138";
            port = 10222;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "glpi" = {
            hostname = "37.205.14.138";
            port = 10422;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "mail" = {
            hostname = "192.168.122.100";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "matomo" = {
            hostname = "192.168.122.103";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "mediawiki" = {
            hostname = "192.168.122.105";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "mesta-services" = {
            hostname = "37.205.14.138";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "mesta-libvirt" = {
            hostname = "37.205.14.17";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "midpoint" = {
            hostname = "192.168.122.102";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "nia" = {
            hostname = "37.205.14.138";
            port = 10722;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "proxy" = {
            hostname = "192.168.122.104";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "status" = {
            hostname = "83.167.228.98";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "roundcube" = {
            hostname = "37.205.14.138";
            port = 10322;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "sympa" = {
            hostname = "192.168.122.101";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "ucto" = {
            hostname = "37.205.14.138";
            port = 10822;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "wp" = {
            hostname = "37.205.14.138";
            port = 10522;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "matrix" = {
            hostname = "37.205.14.138";
            port = 10922;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
        };
      };
    };
  };
}
