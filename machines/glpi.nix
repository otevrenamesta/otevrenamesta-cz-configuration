{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     #php
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 ];

     domain = "otevrenamesta.cz";
     hostName =  "glpi";

  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ ln srk deploy rp1 rp2 rp3 ];

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;

  services.nginx.enable = true;
  services.nginx.virtualHosts."glpi.otevrenamesta.cz" = {
    forceSSL = false;
    enableACME = false; 
    
    root = "/var/www/glpi";
    extraConfig = ''
      location = /index.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
      location = /apixmlrpc.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
      location = /apirest.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
      location = /status.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
      location = /test.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
#start by practice
      location = /install/install.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
      location = /front/login.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
      location = /front/central.php {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
  #přestalo mě bavit to dělat pro každý script extra
      location ~* ^.+.php$ {
        fastcgi_pass unix:/run/phpfpm-glpi.sock;
      }
#end
      location = /robots.txt {
          return 200 "User-agent: *\nDisallow: /\n";
      }
      location ~ ^/(?:core|lang|misc)/ {
          return 403;
      }
      location ~* .(?:bat|git|ini|sh|txt|tpl|xml|md)$ {
          #return 403;
      }
      #location ~* ^.+.php$ {
      #    return 403;
      #}
    '';
    locations."/".index = "index.php";
  };

  services.phpfpm.pools = {
    glpi = {
      listen = "/run/phpfpm-glpi.sock";
      phpPackage = pkgs.php;
      extraConfig = ''
        user = nginx
        pm = dynamic
        pm.max_children = 75
        pm.start_servers = 10
        pm.min_spare_servers = 5
        pm.max_spare_servers = 20
        pm.max_requests = 500
      '';
    };
  };

  services.phpfpm.phpOptions = ''
      memory_limit = 64M ;        // max memory limit
      file_uploads = on ;
      max_execution_time = 600 ;  // not mandatory but recommended
      register_globals = off ;    // not mandatory but recommended
      magic_quotes_sybase = off ;
      session.auto_start = off ;
      session.use_trans_sid = 0 ; // not mandatory but recommended
    '';

}
