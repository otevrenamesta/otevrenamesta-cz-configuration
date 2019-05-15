{ config, lib, pkgs, ... }:
{
  imports = [
    "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
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
            hostname = "37.205.14.17";
            port = 10022;
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
        };
      };
    };
  };
}
