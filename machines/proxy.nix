{ config, pkgs, ... }:

{
  networking = {
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  services.prometheus.exporters.nginx = {
    enable = true;
    openFirewall = true;
  };

  services.nginx = {
    enable = true;
    statusPage = true;
    clientMaxBodySize = "2G";
    #recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

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
              proxy_set_header Host $host;
            '';
          };
        };
      };

      "cityvizor.cz" = {
        serverAliases = [ "www.cityvizor.cz" "demo.cityvizor.cz" ];
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.126:80";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
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

      #"diskurz.otevrenamesta.cz" = {
      #  forceSSL = true;
      #  #addSSL = true;dd
      #  enableACME = true;
      #
      #  locations = {
      #    "/" = {
      #      proxyPass = "http://[2a03:3b40:7:5:5054:ff:fe99:cc48]";
      #      #Y/N? proxyPass = "http://37.205.14.138";
      #    };
      #  };
      #};

      "dsw.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:11180";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };

      "dsw2.otevrenamesta.cz" = {
        serverAliases = [ "praha12.dsw2.otevrenamesta.cz" "praha14.dsw2.otevrenamesta.cz" "praha3.dsw2.otevrenamesta.cz" "novemestonm.dsw2.otevrenamesta.cz" "dotace.praha3.cz" "dotace.praha12.cz" "dotace.praha8.cz" "dotace.praha14.cz" ];
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://185.8.165.109";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };
        };
      };

      "forum.vesp.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://[2a03:3b40:fe:32::]";
            extraConfig = ''
              proxy_set_header Host $host;
            '';
          };
        };
      };

      "forum.otevrenamesta.cz" = {
        serverAliases = [ "vesp.cz" ];
        forceSSL = true;
        enableACME = true;

        extraConfig = ''
          location = /registrace {
            return 301 https://ec.europa.eu/eusurvey/runner/VeSP2020;
          }
          location / {
            return 301 https://forum.vesp.cz$request_uri;
          }
          location /_matrix {
            proxy_pass http://37.205.14.138:10984;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          }

        '';
      };

      # 200203 docasne, bude nahrazeno konferencnim webem
      "www.vesp.cz" = {
        forceSSL = true;
        enableACME = true;

        extraConfig = ''
          location /2020/ {
            alias /var/www/;
            autoindex off;
          }
          location /2020 {
            return 301 https://www.vesp.cz/2020/;
          }
          location = /faktomluva {
            return 301 https://ec.europa.eu/eusurvey/runner/Faktomluva;
          }
          location = /registrace {
            return 301 https://ec.europa.eu/eusurvey/runner/VeSP2020;
          }
          location / {
            return 301 https://www.otevrenamesta.cz/2020/VeSP2020.html;
          }
        '';
      };

      "glpi.otevrenamesta.cz" = {
        forceSSL = true;
        #addSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10480";
            extraConfig = ''
              proxy_set_header Host $host;
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
            #proxyPass = "http://37.205.14.17:10180";
            proxyPass = "http://192.168.122.101";
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

      "matrix.vesp.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10984";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
          };
        };
      };

      "midpoint.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            #proxyPass = "http://37.205.14.17:10280";
            proxyPass = "http://192.168.122.102:8080";
          };
        };
      };

      # needed for mail server to obtain LE cert
      "mx.otevrenamesta.cz" = {
        enableACME = true;
        addSSL = true;
        acmeFallbackHost = "192.168.122.100";
      };

      "navstevnost.otevrenamesta.cz" = {
        enableACME = true;
        forceSSL = true;

        locations = {
          "/" = {
            #proxyPass = "http://37.205.14.17:10380";
            proxyPass = "http://192.168.122.103";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Server $host;
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
              proxy_set_header Host $host;
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

      "riot.vesp.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://37.205.14.138:10980";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
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
                   proxy_set_header Host $host;
               }
          location ^~ /hosting/discovery {
                   proxy_pass http://172.16.9.44:9980;
                   proxy_set_header Host $host;
               }
          # main websocket
          location ~ ^/lool/(.*)/ws$ {
              proxy_pass http://172.16.9.44:9980;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_read_timeout 36000s;
          }

          location ~ ^/lool {
                   proxy_pass http://172.16.9.44:9980;
                   proxy_set_header Upgrade $http_upgrade;
                   proxy_set_header Connection "upgrade";
                   proxy_set_header Host $host;
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
            proxyPass = "https://otevrenamesta.gitlab.io";
            extraConfig = ''
              proxy_set_header Host otevrenamesta.gitlab.io;
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
              proxy_set_header Host $host;
            '';
          };
        };
      };

      "ukoly.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "https://[2a01:430:17:1::ffff:10]";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Real-IP $remote_addr;
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
              proxy_set_header Host $host;
            '';
          };
        };
      };

      "wiki.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "wiki.vesp.cz" ];

        locations = {
          "/" = {
            proxyPass = "http://192.168.122.105";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Forwarded-Host $host;
              proxy_set_header X-Forwarded-Server $host;
            '';
          };
        };
      };

      "wp.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "p7.wp.otevrenamesta.cz" "ck.wp.otevrenamesta.cz" "paro.wp.otevrenamesta.cz" "www2.vesp.cz" ];

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
        serverAliases = [ "otevrenamesta.cz" ];

        locations = {
          "/" = {
            proxyPass = "https://otevrenamesta.gitlab.io";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-Proto $scheme;
            '';
          };

          "/_matrix" = {
            proxyPass = "http://37.205.14.138:10984";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
          };
        };
      };
    };
  };
}
