{ config, lib, pkgs, ... }:
{
  imports = [
    "${builtins.fetchTarball https://github.com/vpsfreecz/nixos-modules/archive/master.tar.gz}"
  ];
  virtualisation.libvirtd = {
    enable = true;
    networking = {
      enable = true;
      infiniteLeaseTime = true;
    };
  };

  environment.systemPackages = with pkgs; [
    screen
    git
  ];
}
