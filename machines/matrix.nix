{ config, pkgs, ... }:

let
  riotConfig = {
    default_server_config = {
      "m.homeserver" = {
        base_url = "https://matrix.vesp.cz";
        server_name = "vesp.cz";
      };
    };
    defaultCountryCode = "CZ";
    # don't allow choosing custom homeserver
    disable_custom_urls = true;
    branding = {
      authHeaderLogoUrl = "/vesp-logo.svg";
      authFooterLinks = [
	{ text = "Provozují Otevřená města, z.s."; url = "https://www.otevrenamesta.cz"; }
	{ text = "Server poskytuje vpsFree.cz, z.s."; url = "https://www.vpsfree.cz"; }
      ];
    };
    embeddedPages.welcomeUrl = "/vesp-welcome.html";
  };
  riotPkg = pkgs.riot-web.override { conf = riotConfig; };
  synapsePkg = pkgs.matrix-synapse.overrideAttrs (attrs: {
    # https://github.com/matrix-org/synapse/pull/7006
    # probably won't be accepted, can be handled by proxy instead
    patches = attrs.patches ++ [
      ../packages/synapse-web-client-redirect.patch
    ];
  });
in
{
  nixpkgs.overlays = [
    # https://github.com/matrix-org/synapse/issues/6211
    # https://twistedmatrix.com/trac/ticket/9740
    # https://github.com/twisted/twisted/pull/1225
    (self: super: {
      python3 = super.python3.override {
        packageOverrides = python-self: python-super: {
          twisted = python-super.twisted.overrideAttrs (attrs: {
            name = "patched-Twisted-18.9.0";
            # package overrides patchPhase, adding patch to `patches` does nothing
            patchPhase = attrs.patchPhase + ''
              patch -p1 < ${../packages/twisted-smtp-tlsv10.patch}
            '';
          });
        };
      };
    })
  ];

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
    package = synapsePkg;
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
      # see the comment above synapsePkg definition
      web_client_location: "https://riot.vesp.cz/"

      email:
        smtp_host: mx.otevrenamesta.cz
        smtp_port: 25
        require_transport_security: true
        notif_from: "Matrix <info@otevrenamesta.cz>"
    '';

    enable_registration = true;
#    enable_registration_captcha = true;
#    recaptcha_public_key = ./matrix/recaptcha.pub;
#    recaptcha_private_key = ./matrix/recaptcha;
  };

  services.nginx = {
    enable = true;
    virtualHosts."riot.vesp.cz" = {
      root = riotPkg;
      locations."=/vesp-logo.svg".alias = ../media/vesp135px-matrix.svg;
      # keep this in sync with ${riotPkg}/welcome.html
      locations."=/vesp-welcome.html".alias = ../media/matrix-welcome.html;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      8448  # Matrix federation and client connections
      80    # nginx+riot
    ];
  };
}
