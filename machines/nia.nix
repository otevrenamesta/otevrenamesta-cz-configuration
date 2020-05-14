{ config, lib, pkgs, ... }:

{
  imports = [
    ../modules/nia-otevrenamesta-cz.nix
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "nia";
  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ ms ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "127.0.0.1";
    ensureDatabases = [ "niatest" ];
    ensureUsers = [
      {
        name = "niatest";
        ensurePermissions = {
          "niatest.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  services.nia-otevrenamesta-cz = {
    enable = true;
    hostName = "${config.networking.hostName}.${config.networking.domain}";
    configFile = "/var/lib/nia-otevrenamesta-cz/config.php";
    privateKeyFile = "/var/lib/nia-otevrenamesta-cz/private.key";
  };

  services.nginx.virtualHosts.${config.services.nia-otevrenamesta-cz.hostName} = {
    serverAliases = [ "test.nia.otevrenamesta.cz" ];
  };
}
