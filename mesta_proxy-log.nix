{
  network.description = "Mesta - proxy";

  proxy =
    { config, pkgs, ... }:

    {

      environment.systemPackages = with pkgs; [
        htop
        lynx
        screen
        vim
        wget
      ];

      ## pro test upraveneho webserveru
      # services.httpd.enable = true;
      # services.httpd.adminAddr = "webmaster@otevrenamesta.cz";
      # services.httpd.documentRoot = "${pkgs.valgrind.doc}/share/doc/valgrind/html";

      ## web proxy (nahrada stavajiciho)
      services.openssh.enable = true;
      users.extraUsers.root.openssh.authorizedKeys.keys =
        with import ./ssh-keys.nix; [ ln srk ];

      services.nginx = {
        enable = true;


        virtualHosts = {
          "sproxy.otevrenamesta.cz" = {
            default = true;
            #forceSSL = true;
            #addSSL = true;
            #enableACME = true;

            locations = {
              "/" = {
                root = "/var/www";
              };
            };
          };

          "virtuoso.otevrenamesta.cz" = {
            #forceSSL = true;
            #addSSL = true;
            #enableACME = true;

            locations = {
              "/" = {
                proxyPass = "http://77.93.223.72:8890";
              };
            };
          };

          "swww.otevrenamesta.cz" = {
            #forceSSL = true;
            #addSSL = true;
            #enableACME = true;

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

      networking.firewall.allowedTCPPorts = [ 80 443 ];
    };
}
