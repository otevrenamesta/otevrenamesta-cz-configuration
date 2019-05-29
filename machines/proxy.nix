{ config, pkgs, ... }:

{
  networking = {
     firewall.allowedTCPPorts = [ 80 443 ];
   };

  services.nginx = {
    enable = true;
    clientMaxBodySize = "2G";
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
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
          };
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

        locations = {
          "/" = {
            proxyPass = "http://172.16.9.44";
            #proxyPass = "http://[2a01:430:17:1::ffff:689]";
          };
        };
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

      "virtuoso.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;

        locations = {
          "/" = {
            proxyPass = "http://77.93.223.72:8890";
          };
        };
      };

      "www.otevrenamesta.cz" = {
        default = true;
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
    };
  };
}
