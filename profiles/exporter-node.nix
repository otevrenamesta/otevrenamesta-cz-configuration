{ config, pkgs, lib, ... }:
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" "logind" "processes" ];
    openFirewall = true;
  };
}
