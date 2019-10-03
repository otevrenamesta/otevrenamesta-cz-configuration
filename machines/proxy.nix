{ config, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    #htop
  ];

  networking = {
     #Y/N? hostName =  lib.mkForce "proxy";
     firewall.allowedTCPPorts = [ 80 443 ];
   };

  #Y/N?services.openssh.enable = true;
  #Y/N?users.extraUsers.root.openssh.authorizedKeys.keys =
  #Y/N?  with import ./ssh-keys.nix; [ ln srk ];

  users.users.niap = {
    description = "NIA proxy user (no shell, port forwarding only)";
    shell = "${pkgs.shadow}/bin/nologin";
    openssh.authorizedKeys.keys = with import ../ssh-keys.nix; [ ms ln mm ];
  };

  services.nginx = {
    enable = true;
    clientMaxBodySize = "2G";
    #recommendedProxySettings = true;
    #recommendedTlsSettings = true;

    virtualHosts = {

      "booked.otevrenamesta.cz" = {
        #forceSSL = true;
        addSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            #proxyPass = "http://[2a03:3b40:fe:32::]";
            proxyPass = "http://37.205.14.138";
            extraConfig = ''
              rewrite ^/$ /Web/index.php redirect;
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
            proxyPass = "http://[2a03:3b40:fe:32::]";
            extraConfig = ''
              proxy_set_header Host $http_host;
            '';
          };
        };
      };

      "glpi.otevrenamesta.cz" = {
        #forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10480";
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
            #proxyPass = "http://[2a03:3b40:100::1:467]:3000";
            proxyPass = "http://37.205.14.2";
          };
        };
        locations."/ws" = {
          proxyPass = "http://37.205.14.2";
          extraConfig = '' 
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
          '';
        };
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

      "lists.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.17:10180";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header Front-End-Https On;
            '';

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

      "navstevnost.otevrenamesta.cz" = {
        enableACME = true;
        forceSSL = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.17:10380";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';

          };
        };
      };

      "nia.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10780";
            extraConfig = ''
              proxy_set_header Host $http_host;
            '';
          };
        };
      };

      "p7.otevrenamesta.cz" = {
        forceSSL = false;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:3::44]";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
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

      "test.nia.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10780";
            extraConfig = ''
              proxy_set_header Host $http_host;
            '';
          };
        };
      };

      "ucto.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10880";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Real-IP $remote_addr;
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

      "webmail.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10380";
            extraConfig = ''
              proxy_set_header Host $http_host;
            '';
          };
        };
      };

      "wp.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;
        # i don't think enableACME works with wildcard certs, at least not in this nixpkgs version anyway
        serverAliases = [ "p7.wp.otevrenamesta.cz" "ck.wp.otevrenamesta.cz" "paro.wp.otevrenamesta.cz" ];

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10580";
            extraConfig = ''
              proxy_set_header        Host $host;
              proxy_set_header        X-Real-IP $remote_addr;
              proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header        X-Forwarded-Proto $scheme;
              proxy_set_header        X-Forwarded-Host $host;
              proxy_set_header        X-Forwarded-Server $host;
            '';
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
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };
    };
  };
}
