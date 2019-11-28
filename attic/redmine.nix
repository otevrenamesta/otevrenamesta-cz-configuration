{ config, pkgs, lib, ...}:

{
  # XXX: redmine needs an update
  #services.redmine = {
  #  enable = true;
  #  databasePassword = "test";
  #};

  networking.firewall = {
    allowedTCPPorts = [ 80 ];
  };

  services.postgresql = {
    enable = true;
  };
}
