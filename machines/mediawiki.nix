{ config, pkgs, ... }:

{
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
    name = "Otevřená města";
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
      ];
      extraConfig = ''
        # https://www.mediawiki.org/wiki/Manual:Short_URL/Apache
        RewriteEngine On
        # do not rewrite uploadsDir nor logo.svg
        RewriteCond %{REQUEST_URI} !^/images/
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-f
        RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} !-d
        RewriteRule ^(.*)$ %{DOCUMENT_ROOT}/index.php [L]
      '';
    };
    # versions of extensions must match MediaWiki version!
    extensions = {
      VisualEditor = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/VisualEditor-REL1_33-f64e411.tar.gz";
        sha256 = "1czdgz2d3jraw1vkpiby9lxb9jiqnqqkv8g1rxifb141jx6659qh";
      };
      ParserFunctions = pkgs.fetchzip {
        url = "https://extdist.wmflabs.org/dist/extensions/ParserFunctions-REL1_33-4395442.tar.gz";
        sha256 = "0d85qrmivb64w9x6hbkl2jmlb14qgma1nr2q6zksi619gvzmdl4y";
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
    '';
  };

  services.parsoid_ = {
    enable = true;
    wikis = [ "http://localhost/api.php" ];
  };

  services.mysql = {
    enable = true;
  };
  
}
