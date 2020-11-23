{ config, pkgs, lib, ... }:

let
  vpsadminos = builtins.fetchTarball {
    url = "https://github.com/vpsfreecz/vpsadminos/archive/a74c43f68034bfc4fe2c5d73ec7533b9d71e1be7.tar.gz";
    sha256 = "1x59a1v7dph03czaq83hh22kqb393jq0hhz6hng3yy8gvv1ysybr";
  };
in
{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/container-config.nix>
    "${vpsadminos}/os/lib/nixos-container/vpsadminos.nix"
  ];

  systemd.services.systemd-udev-trigger.enable = false;

  # vpsf doesn't use dhcp for interface configuration
  # configure with networking.interfaces.<name?>.useDHCP as needed
  networking.useDHCP = false;

  services.resolved.enable = false;
}

