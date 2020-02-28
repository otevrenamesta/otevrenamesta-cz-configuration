{ config, pkgs, lib, ... }:

with lib;

{
  # can be removed after upgrading to NixOS-20.03
  imports = [
    ../modules/parsoid_.nix
  ];

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
      servedFiles = [
        { file = ../media/vesp135px.svg; urlPath = "/images/logo.svg"; }
        { file = ../media/vesp-favicon.ico; urlPath = "/favicon.ico"; }
      ];
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
        url = "https://extdist.wmflabs.org/dist/extensions/VisualEditor-REL1_33-f64e411.tar.gz";
        sha256 = "1czdgz2d3jraw1vkpiby9lxb9jiqnqqkv8g1rxifb141jx6659qh";
      };
      ParserFunctions = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/ParserFunctions-REL1_33-4395442.tar.gz";
        sha256 = "0d85qrmivb64w9x6hbkl2jmlb14qgma1nr2q6zksi619gvzmdl4y";
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
    '';
  };

  warnings = let
    extVersion = "1.33";
    mwVersion = config.services.mediawiki.package.version;
  in
  optional (!hasPrefix extVersion mwVersion) ''
    Possible MediaWiki version mismatch: extensions are for ${extVersion} but MW is ${mwVersion}.
    Please update `services.mediawiki.extensions` as well as this warning.
  '';

  services.parsoid_ = {
    enable = true;
    wikis = [ "http://localhost/api.php" ];
  };

  services.mysql = {
    enable = true;
  };
  
}
