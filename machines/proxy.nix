{ config, pkgs, ... }:

{

  #Y/N? environment.systemPackages = with pkgs; [
  #Y/N?   htop
  #Y/N?   lynx
  #Y/N?   screen
  #Y/N?   vim
  #Y/N?   wget
  #Y/N? ];

  networking = {
     #Y/N? hostName =  lib.mkForce "proxy";
     firewall.allowedTCPPorts = [ 80 443 ];
   };

  #Y/N?services.openssh.enable = true;
  #Y/N?users.extraUsers.root.openssh.authorizedKeys.keys =
  #Y/N?  with import ./ssh-keys.nix; [ ln srk ];

  services.nginx = {
    enable = true;
    clientMaxBodySize = "2G";
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {

      "booked.otevrenamesta.cz" = {
        #forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            #proxyPass = "http://[2a03:3b40:fe:32::]";
            proxyPass = "http://37.205.14.138";
            extraConfig = ''
               proxy_set_header Host $http_host;
            '';
          };
        };
      };

      "ckan.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:27]";
          };
        };
      };

      "ckandevel.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://77.93.223.72:5000";
          };
        };
      };

      "diskurz.otevrenamesta.cz" = {
        forceSSL = true;
        #addSSL = true;dd
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:7:5:5054:ff:fe99:cc48]";
            #Y/N? proxyPass = "http://37.205.14.138";
          };
        };
      };

      "forum.otevrenamesta.cz" = {
        forceSSL = true;
        #addSSL = true;dd
        enableACME = true;

        locations = {
          "/" = {
            #proxyPass = "http://[2a03:3b40:7:5:5054:ff:fe99:cc48]";
            proxyPass = "http://[fe80::5054:ff:fe99:cc48]";
          };
        };
      };

      "glpi.otevrenamesta.cz" = {
        #forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138";
            extraConfig = ''
              proxy_set_header Host $http_host;
            '';
          };
        };
      };

      "idp.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:1382]:8080";
          };
        };
      };

      "iot.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:100::1:467]:3000";
            #Y/N? proxyPass = "http://37.205.14.2";
          };
        };
        #Y/N? locations."/ws" = {
        #Y/N?   proxyPass = "http://37.205.14.2";
        #Y/N?   extraConfig = '' 
        #Y/N?     proxy_http_version 1.1;
        #Y/N?     proxy_set_header Upgrade $http_upgrade;
        #Y/N?     proxy_set_header Connection "upgrade";
        #Y/N?     proxy_set_header Host $host;
        #Y/N?   '';
        #Y/N? };
      };

      "kmd.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:643]";
          };
        };
      };

      "kmddevel.otevrenamesta.cz" = {
        locations = {
          "/" = {
            proxyPass = "http://172.16.9.47:5000";
          };
        };
      };

      "ldap.otevrenamesta.cz" = {
        #forceSSL = true;
        #enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://172.16.9.36:9830";
          };
        };
      };

      "lpetl.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        basicAuth = {
          user1 = "heslo1";
          user2 = "heslo2";
        };

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:27]:8088";
          };
        };
      };

      "midpoint.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:1309]:8080";
          };
        };
      };

      "projekty.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:1381]:8080";
          };
        };
      };

      "proxy.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            root = "/var/www";
          };
        };
      };

      "skmd.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:7:5:5054:ff:fe39:be8e]";
          };
        };
      };

      "skod.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:7:5:5054:ff:fe43:f292]";
          };
        };
      };

      "soubory.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "az.otevrenamesta.cz" ];

        extraConfig = ''
          location ^~ /loleaflet {
                   proxy_pass http://172.16.9.44:9980;
                   #proxyPass = "http://[2a01:430:17:1::ffff:689]"; 
                   proxy_set_header Host $http_host;
               }
          location ^~ /hosting/discovery {
                   proxy_pass http://172.16.9.44:9980;
                   proxy_set_header Host $http_host;
               }
          # main websocket
          location ~ ^/lool/(.*)/ws$ {
              proxy_pass http://172.16.9.44:9980;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $http_host;
              proxy_read_timeout 36000s;
          }

          location ~ ^/lool {
                   proxy_pass http://172.16.9.44:9980;
                   proxy_set_header Upgrade $http_upgrade;
                   proxy_set_header Connection "upgrade";
                   proxy_set_header Host $http_host;
               }
          location / {
              proxy_pass http://172.16.9.44;
              #proxy_pass http://[2a01:430:17:1::ffff:689]
              proxy_pass_header Authorization;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP  $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_http_version 1.1;
              proxy_set_header Connection "";
              proxy_buffering off;
              proxy_request_buffering off;
              client_max_body_size 0;
              proxy_read_timeout  36000s;
              proxy_redirect off;
              proxy_ssl_session_reuse off;
               }
          '';
      };

      "sp.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a01:430:17:1::ffff:1383]";
          };
        };
      };


      "swww.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "https://otevrenamesta.github.io";
            extraConfig = ''
              proxy_set_header Host otevrenamesta.github.io;
            '';
          };
        };
      };

      "ucto.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.12.35:8080";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };

      "virtuoso.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://77.93.223.72:8890";
          };
        };
      };

      "wp.otevrenamesta.cz" = {
        #forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:fe:34::]";
          };
        };
      };

      "www.otevrenamesta.cz" = {
        default = true;
        forceSSL = true;
        enableACME = true;
        serverAliases = ["otevrenamesta.cz"];

        locations = {
          "/" = {
            proxyPass = "https://otevrenamesta.github.io";
            extraConfig = ''
              proxy_set_header Host otevrenamesta.github.io;
            '';
          };
        };
      };
    };
  };
}
