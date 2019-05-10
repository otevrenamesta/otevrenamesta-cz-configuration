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

  networking.nat = {
     forwardPorts = [
       { destination = "192.168.122.100:22"; sourcePort = 10022;} # mail
       { destination = "192.168.122.101:22"; sourcePort = 10122;} # sympa
       { destination = "192.168.122.102:22"; sourcePort = 10222;} # ?
     ];
  };

  environment.systemPackages = with pkgs; [
    screen
    git
  ];
}
