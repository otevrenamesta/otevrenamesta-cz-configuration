{ config, pkgs, lib, ...}:

let
  bigFileNginx = ''
    client_body_in_file_only clean;
    client_body_buffer_size 32K;

    # set max upload size
    client_max_body_size 2G;

    sendfile on;
    send_timeout 3600s;
  '';

in

{

  networking.firewall = {
    allowedTCPPorts = [ 80 ];
  };

  services.nginx = {
    enable = true;

    recommendedProxySettings = true;

    virtualHosts = {
      "ckan" = {
        default = true;
        locations = {
          "/" = {
            proxyPass = "http://ckan";
            extraConfig = ''
              ${bigFileNginx}
            '';
          };
        };
      };

      "ckan-pub" = {
        locations = {
          "/" = {
            proxyPass = "http://ckan-pub";
            extraConfig = ''
              ${bigFileNginx}
            '';
          };
        };
      };

      "lpetl" = {
        locations = {
          "/" = {
            proxyPass = "http://lpetl:8080";
          };
        };

        basicAuth = {
          lpetl-user = lib.fileContents ./static/lpetl-user-password.secret;
        };
      };

    };
  };
}
