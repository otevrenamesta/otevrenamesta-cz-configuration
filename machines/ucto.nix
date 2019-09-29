{ config, pkgs, ... }:

{
  imports = [
    ../modules/proplaceni.nix
  ];

  environment.systemPackages = with pkgs; [
    tmux
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "ucto2";
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = with import ../ssh-keys.nix; [ jh ];

  services.proplaceni = {
    enable = true;
    webHost = "ucto2.otevrenamesta.cz";
    settingsGlobal = "/etc/proplaceni/settings_global.py";
    settingsLocal = "/etc/proplaceni/settings_local.py";
  };

  services.nginx = {
    enable = true;
    virtualHosts."ucto2.otevrenamesta.cz" = {
      forceSSL = false;
      enableACME = false; 
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_11;
    ensureDatabases = [ "proplaceni" ];
    ensureUsers = [{
      name = "proplaceni";
      ensurePermissions = {
        "DATABASE proplaceni" = "ALL PRIVILEGES";
      };
    }];
  };

  systemd.services.proplaceni.environment = {
    #PIROPLACENI_DEBUG = "b-on";
    PIROPLACENI_BASE_DOMAIN = "s-otevrenamesta.cz";
    PIROPLACENI_BASE_SUBDOMAIN = "s-ucto2.";
  };
}

