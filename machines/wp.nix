{ config, pkgs, ... }:

let

  # For shits and giggles, let's package the responsive theme
  responsiveTheme = pkgs.stdenv.mkDerivation {
    name = "responsive-theme";
    # Download the theme from the wordpress site
    src = pkgs.fetchurl {
      url = http://wordpress.org/themes/download/responsive.1.9.7.6.zip;
      sha256 = "1g1mjvjbx7a0w8g69xbahi09y2z8wfk1pzy1wrdrdnjlynyfgzq8";
    };
    # We need unzip to build this package
    buildInputs = [ pkgs.unzip ];
    # Installing simply means copying all files to the output directory
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  # Wordpress plugin 'akismet' installation example
  akismetPlugin = pkgs.stdenv.mkDerivation {
    name = "akismet-plugin";
    # Download the theme from the wordpress site
    src = pkgs.fetchurl {
      url = https://downloads.wordpress.org/plugin/akismet.3.1.zip;
      sha256 = "1wjq2125syrhxhb0zbak8rv7sy7l8m60c13rfjyjbyjwiasalgzf";
    };
    # We need unzip to build this package
    buildInputs = [ pkgs.unzip ];
    # Installing simply means copying all files to the output directory
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

in

{

  environment.systemPackages = with pkgs; [
    wp-cli
  ];

  networking = {
     firewall.allowedTCPPorts = [ 80 443 ];

     domain = "otevrenamesta.cz";
     hostName =  "wp";
  };


  services.mysql = {
    enable = true;
    package = pkgs.mysql;
  };

  services.wordpress."wp.otevrenamesta.cz" = {
    package = pkgs.wordpress.overrideAttrs (attrs: {
      version = "5.2.6";
      src = pkgs.fetchurl {
        url = "https://wordpress.org/wordpress-5.2.6.tar.gz";
        sha256 = "1svzxlnbw3ibb1vvnf4xg4g2ckz55rsj2vyb7vy1pi5sqal2v6iq";
      };
    });
    database = {
      host = "127.0.0.1";
      createLocally = true;
      name = "wordpress";
      passwordFile = pkgs.writeText "wordpress-insecure-dbpass" "wordpress"; # FIXME
      #socket = ""; #??
    };
    extraConfig = ''
      define('WP_ALLOW_MULTISITE', true);
      define('WP_DEFAULT_THEME', 'responsive-theme');

      define('MULTISITE', true);
      define('SUBDOMAIN_INSTALL', true);
      define('DOMAIN_CURRENT_SITE', 'wp.otevrenamesta.cz');
      define('PATH_CURRENT_SITE', '/');
      define('SITE_ID_CURRENT_SITE', 1);
      define('BLOG_ID_CURRENT_SITE', 1);

      define( 'AUTH_KEY', '|[s#O(5VN>iL5/kDUEf45.&U)Oix|W+d[Q(=W5pz&A|,#TPXY$xa@|H|RrX2]%*;' );
      define( 'SECURE_AUTH_KEY', '}pKf{5=*6WG2?X98,%;*w+E.~s9erMU<Tj}Xg.V3PVqt_E8B0W1#D|T)+x{IkZ8-' );
      define( 'LOGGED_IN_KEY', 'Ygi#:[kK1EdWnis|-prey2P$c8$k0^vd</1VRk-y&J%X~-g^q2)i3,+CjD-:6uq8' );
      define( 'NONCE_KEY', 'r#w!Dl8n1(y#@L*I9__*&*VH/SwcAxEZ,CT)(sGKI-{xL;EMEe< L`>-m{eVund}' );
      define( 'AUTH_SALT', 'N^/lca0M (&wjQFC6nE*F|TqoJ&zXAo_/2-%,,S@{u2bPKG.JU`qdO?o;GDIQ9-a' );
      define( 'SECURE_AUTH_SALT', 'f1BHpxE-T745-OD&K7Wyzr{QK~3yOGSPUDQOscDyV*v+Q$ :3Ju^YLtHlWgp@_%-' );
      define( 'LOGGED_IN_SALT', '_yZ+};<lULD}@D=QlcrZ.Lm#+eW>O~j|Uux!O_k_SF[FW|P#!fX;N+=3L+-;~Afj' );
      define( 'NONCE_SALT', 'F!WaPg$!S,oRqYOB5~N1Z6W$01*KV!`8Z;PtGnE9-R+{7+qNmIx$wYRL<`gu%S_C' );

      if($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){
          $_SERVER['HTTPS'] = 'on';
          $_SERVER['SERVER_PORT'] = 443;
      }

      // If you get an error about cookies being blocked when you try to log in to your network
      // subsite (or log in fails with no error message), open your wp-config.php file and add this
      // line after the other code you added to create the network:
      define('COOKIE_DOMAIN', $_SERVER['HTTP_HOST']);
    '';
    themes = [ responsiveTheme ];
    plugins = [ akismetPlugin ];
    virtualHost = {
      adminAddr = "ladislav.nesnera@otevrenamesta.cz";
    };
  };

  services.httpd = {
    enable = true;
    logPerVirtualHost = true;
    adminAddr="ladislav.nesnera@otevrenamesta.cz";
  };

}
