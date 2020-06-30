{ config, pkgs, lib, ... }:

let
  vpsadminos = builtins.fetchTarball https://github.com/vpsfreecz/vpsadminos/archive/master.tar.gz;
in
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/container-config.nix>
    "${vpsadminos}/os/lib/nixos-container/build.nix"
    "${vpsadminos}/os/lib/nixos-container/networking.nix"
  ];

  systemd.services.systemd-udev-trigger.enable = false;

  # vpsf doesn't use dhcp for interface configuration
  # configure with networking.interfaces.<name?>.useDHCP as needed
  networking.useDHCP = false;

  services.resolved.enable = false;
}

