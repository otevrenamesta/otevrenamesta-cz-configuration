{ config, pkgs, lib, ... }:

with lib;

{
  environment.systemPackages = with pkgs; [
  ];

  networking = {
     firewall.allowedTCPPorts = [ 22 80 ];

     hostName = "wiki";
     domain = "otevrenamesta.cz";
  };

  services.mediawiki = {
    enable = true;
    name = "Veřejná správa prakticky - pískoviště";
    passwordFile = "/run/keys/mediawikiadmin";
    database = {
      type = "mysql";
      createLocally = true;
    };
    virtualHost = {
      hostName = "wiki.vesp.cz";
      serverAliases = [ "${config.networking.hostName}.${config.networking.domain}" ];
      adminAddr = "info@otevrenamesta.cz";
      locations = {
        "/images/logo.svg".alias = ../media/vesp135px.svg;
        "/favicon.ico".alias = ../media/vesp-favicon.ico;
      };
      extraConfig = ''
        # https://www.mediawiki.org/wiki/Manual:Short_URL/Apache
        RewriteEngine On
        # do not rewrite uploadsDir, logo.svg, favicon.ico
        RewriteCond %{REQUEST_URI} !^/favicon.ico
        RewriteCond %{REQUEST_URI} !^/images/
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
        RewriteRule ^(.*)$ %{DOCUMENT_ROOT}/index.php [L]
      '';
    };
    # Versions of extensions must match MediaWiki version!
    # After updating the extensions please also update the `warnings` expression below.
    extensions = {
      VisualEditor = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/VisualEditor-REL1_34-74116a7.tar.gz";
        sha256 = "12lwna2qlc80smba2ci4ig144ppq6b6rwm1jdcx9ghixy8ckzkfp";
      };
      ParserFunctions = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/ParserFunctions-REL1_34-4de6f30.tar.gz";
        sha256 = "1rvlphcal24w92icma13ganxjcg541c11209ijfapqrlk8a5y1ks";
      };
      # after 20.09, see also https://github.com/NixOS/nixpkgs/pull/83436
      ConfirmEdit = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/ConfirmEdit-REL1_34-a84d99c.tar.gz";
        sha256 = "094np8zkivxs68vvd52096f3zxc1h8nk272zj9cbyb0zm7z8dc0i";
      };
      Matomo = pkgs.fetchzip {
        url = "https://github.com/DaSchTour/matomo-mediawiki-extension/archive/v4.0.1.tar.gz";
        sha256 = "0g5rd3zp0avwlmqagc59cg9bbkn3r7wx7p6yr80s644mj6dlvs1b";
      };
    };

    extraConfig = ''
      $wgLogo = "/images/logo.svg";
      $wgSquidServers = ["192.168.122.104"]; # IPs of reverse proxies
      $wgSMTP = [
        'host' => "192.168.122.100", # our machine needs to be whitelisted in machines/mail.nix
        'IDhost' => "otevrenamesta.cz",
        'port' => 25,
        'auth' => false,
      ];
      $wgPasswordSender = "noreply@otevrenamesta.cz"; # try setting this to info@otevrenamesta.cz to avoid being classified as spam

      # use https when generating absolute urls, should save some http->https redirects:
      $wgServer = "https://${config.services.mediawiki.virtualHost.hostName}";

      # https://www.mediawiki.org/wiki/Manual:Short_URL
      $wgArticlePath = "/$1";

      ## https://www.mediawiki.org/wiki/Extension:VisualEditor ##
      // Enable by default for everybody
      $wgDefaultUserOptions['visualeditor-enable'] = 1;

      // Optional: Set VisualEditor as the default for anonymous users
      // otherwise they will have to switch to VE
      // $wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

      // Don't allow users to disable it
      $wgHiddenPrefs[] = 'visualeditor-enable';

      $wgVirtualRestConfig['modules']['parsoid'] = array(
          // URL to the Parsoid instance
          // Use port 8142 if you use the Debian package
          'url' => 'http://localhost:8000',
          // Parsoid "domain"
          'domain' => 'localhost',
      );

      # matomo tracking
      $wgMatomoURL = "navstevnost.otevrenamesta.cz";
      $wgMatomoIDSite = "5";

      # anti-spam
      wfLoadExtension('ConfirmEdit/QuestyCaptcha');
      $wgCaptchaQuestions = [
        'Jak se jmenuje druhé největší město ČR?' => 'Brno',
        'Pátý den týdne je?' => [ 'Pátek', 'Patek' ],
        'Pátým měsícem roku je?' => [ 'Květen', 'Kveten' ],
        'Kolik prstů má ruka?' => [ '5', 'Pět', 'Pet' ],
      ];
    '';
  };

  warnings = let
    extVersion = "1.34";
    mwVersion = config.services.mediawiki.package.version;
  in
  optional (!hasPrefix extVersion mwVersion) ''
    Possible MediaWiki version mismatch: extensions are for ${extVersion} but MW is ${mwVersion}.
    Please update `services.mediawiki.extensions` as well as this warning.
  '';

  services.parsoid = {
    enable = true;
    wikis = [ "http://localhost/api.php" ];
  };

  services.mysql = {
    enable = true;
  };

  services.mysqlBackup = {
    enable = true;
    databases = [ "mediawiki" ];
  };
  
}
