{ config, pkgs, ... }:

let
  riotConfig = {
    default_server_config = {
      "m.homeserver" = {
        base_url = "https://matrix.vesp.cz";
        server_name = "vesp.cz";
      };
    };
  };
  riotPkg = pkgs.callPackages ../packages/riot-web.nix { conf = riotConfig; };
in
{
  environment.systemPackages = with pkgs; [
  ];

  networking = {
     hostName = "matrix";
     domain = "vesp.cz";
  };

  users.extraUsers.root.openssh.authorizedKeys.keys =
    with import ../ssh-keys.nix; [ rh ];

  services.postgresql.enable = true;

  services.matrix-synapse = {
    enable = true;
    no_tls = true;
    server_name = "vesp.cz";
    registration_shared_secret = with import ../secrets/matrix.nix; registration-secret;
    public_baseurl = "https://matrix.vesp.cz/";
    database_type = "psycopg2";
    database_args = {
      database = "matrix-synapse";
    };
    listeners = [
      { # federation
        bind_address = "";
        port = 8448;
        resources = [
          { compress = true; names = [ "client" "webclient" ]; }
          { compress = false; names = [ "federation" ]; }
        ];
        tls = false;
        type = "http";
        x_forwarded = true;
      }
    ];
    extraConfig = ''
      max_upload_size: "100M"
    '';

    enable_registration = true;
#    enable_registration_captcha = true;
#    recaptcha_public_key = ./matrix/recaptcha.pub;
#    recaptcha_private_key = ./matrix/recaptcha;
  };

  services.nginx = {
    enable = true;
    virtualHosts."riot.vesp.cz".root = riotPkg;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8448  # Matrix federation and client connections
      80    # nginx+riot
    ];
  };
}
