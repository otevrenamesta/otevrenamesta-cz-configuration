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
  services.ckan = {
    listenPort = 9000;
    listenAddress = "127.0.0.1";
  };
  services.nginx = {
    enable = true;

    recommendedProxySettings = true;

    virtualHosts = {
      "ckan" = {
        default = true;
        locations = {
          "/" = {
            proxyPass = "http://localhost:9000";
            extraConfig = ''
              ${bigFileNginx}
            '';
          };
        };
      };
    };
  };
}
