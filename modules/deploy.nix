{ config, lib, pkgs, ... }:
let
  home-manager-src = builtins.fetchTarball {
    url = "https://github.com/rycee/home-manager/archive/8b15f1899356762187ce119980ca41c0aba782bb.tar.gz";
    sha256 = "17bahz18icdnfa528zrgrfpvmsi34i859glfa595jy8qfap4ckng";
  };
in
{
  imports = [
    "${home-manager-src}/nixos"
  ];

  nixpkgs.overlays = [
    (import ../overlays/morph.nix)
  ];

  environment.systemPackages = with pkgs; [
    morph
    screen
    git
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
          "mail" = {
            hostname = "192.168.122.100";
            #hostname = "37.205.14.17";
            #port = 10022;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "sympa" = {
            hostname = "37.205.14.17";
            port = 10122;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "midpoint" = {
            hostname = "37.205.14.17";
            port = 10222;
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
          "proxy" = {
            hostname = "83.167.228.98";
            user = "root";
            identityFile = "~/.ssh/mesta_deploy";
          };
        };
      };
    };
  };
}
