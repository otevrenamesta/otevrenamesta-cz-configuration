{ config, pkgs, lib, ...}:

{

  networking.firewall = {
    allowedTCPPorts = [ 80 ];
  };

  services.nginx = {
    enable = true;

    virtualHosts = {
      "ckan" = {
        default = true;
        locations = {
          "/" = {
            extraConfig = ''
              proxy_set_header        Host $host;
              proxy_set_header        X-Real-IP $remote_addr;
              proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header        X-Forwarded-Proto $scheme;

              proxy_pass          http://ckan;
              proxy_read_timeout  90;

              # XXX: probably not needed
              #proxy_redirect      http://ckan http://172.17.4.127;

              # big file start
              client_body_in_file_only clean;
              client_body_buffer_size 32K;

              # set max upload size
              client_max_body_size 2G;

              sendfile on;
              send_timeout 3600s;
              # big file end
            '';
          };
        };
      };
      "ckan-pub" = {
        locations = {
          "/" = {
            extraConfig = ''
              proxy_set_header        Host $host;
              proxy_set_header        X-Real-IP $remote_addr;
              proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header        X-Forwarded-Proto $scheme;

              proxy_pass          http://ckan-pub;
              proxy_read_timeout  90;

              # big file start
              client_body_in_file_only clean;
              client_body_buffer_size 32K;

              # set max upload size
              client_max_body_size 2G;

              sendfile on;
              send_timeout 3600s;
              # big file end
            '';
          };
        };
      };
    };
  };
}
