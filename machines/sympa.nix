{ config, pkgs, ... }:

let
  secrets = import ../secrets/sympa.nix;
in
{
  imports = [
    # local copy, get rid of it after upgrading to 20.03
    # delete ../packages/sympa/ as well
    ../modules/sympa-overrides.nix
    ../modules/sympa.nix
  ];

  environment.systemPackages = with pkgs; [ vim ];

  networking = {
     firewall.allowedTCPPorts = [ 80 25 443 ];

     domain = "otevrenamesta.cz";
     hostName =  "lists";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    bind = "127.0.0.1";
    ensureDatabases = [ "sympa" ];
    ensureUsers = [
      {
        name = "sympa";
        ensurePermissions = {
          "sympa.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  documentation.nixos.enable = false;

  services.postfix = {
    enable = true;
    relayHost = "192.168.122.100"; # do NOT use [brackets] here
  };

  # workaround https reverse proxy
  services.nginx.virtualHosts."lists.otevrenamesta.cz".locations."/".extraConfig = ''
    fastcgi_param HTTPS on;
  '';

  services.sympa = {
    enable = true;
    lang = "cs";
    mainDomain = "lists.otevrenamesta.cz";
    domains = {
      "lists.otevrenamesta.cz" = {
        webHost = "lists.otevrenamesta.cz";
      };
    };
    listMasters = [ "martin@martinmilata.cz" "nesnera@email.cz" "ladislav.nesnera@liberix.cz" ];
    web = {
      enable = true;
      fcgiProcs = 2;
      https = false;
    };
    database = {
      type = "MySQL";
      host = "localhost";
      user = "sympa";
    };
    settings = {
      cookie = secrets.cookie;
    };
    settingsFile = {
      "etc/lists.otevrenamesta.cz/scenari/send.privateoreditorkey-whitelist-om".text = ''
        title.gettext Private, moderated for non subscribers, @otevrenamesta.cz whitelisted

        is_subscriber([listname],[sender]) smtp,dkim,md5,smime    -> do_it
        is_editor([listname],[sender])     smtp,dkim,md5,smime    -> do_it
        match([sender], /.*@otevrenamesta.cz/) smtp,dkim,md5,smime -> do_it
        true()                             smtp,dkim,md5,smime    -> editorkey
      '';
    };
  };
}
