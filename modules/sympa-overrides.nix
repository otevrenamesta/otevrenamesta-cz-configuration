{ config, lib, pkgs, ... }:
{
  config = {
    nixpkgs.config.perlPackageOverrides = perlPkgs:
    with pkgs.perlPackages;
    let
      inherit (pkgs) fetchurl;
    in
    rec {
      HTMLStripScriptsParser = perlPkgs.buildPerlPackage {
        pname = "HTML-StripScripts-Parser";
        version = "1.03";
        src = fetchurl {
          url = mirror://cpan/authors/id/D/DR/DRTECH/HTML-StripScripts-Parser-1.03.tar.gz;
          sha256 = "478c1a4e46eb77fa7bce96ba288168f0b98c27f250e00dc6312365081aed3407";
        };
        propagatedBuildInputs = [ HTMLParser HTMLStripScripts ];
        meta = {
          description = "XSS filter using HTML::Parser";
          license = with lib.licenses; [ artistic1 gpl1Plus ];
        };
      };
      HTMLStripScripts = buildPerlPackage {
        pname = "HTML-StripScripts";
        version = "1.06";
        src = fetchurl {
          url = mirror://cpan/authors/id/D/DR/DRTECH/HTML-StripScripts-1.06.tar.gz;
          sha256 = "222bfb7ec1fdfa465e32da3dc4abed2edc7364bbe19e8e3c513c7d585b0109ad";
        };
        meta = {
          description = "Strip scripting constructs out of HTML";
          license = with lib.licenses; [ artistic1 gpl1Plus ];
        };
      };
      MIMEEncWords = buildPerlPackage {
        pname = "MIME-EncWords";
        version = "1.014.3";
        src = fetchurl {
          url = "mirror://cpan/authors/id/N/NE/NEZUMI/MIME-EncWords-1.014.3.tar.gz";
          sha256 = "e9afb548611d4e7e6c50b7f06bbd2b1bb2808e37a810deefb537c67af5485238";
        };
        propagatedBuildInputs = [ MIMECharset ];
        meta = {
          homepage = "https://metacpan.org/pod/MIME::EncWords";
          description = "Deal with RFC 2047 encoded words (improved)";
          license = with lib.licenses; [ artistic1 gpl1Plus ];
          maintainers = [ maintainers.sgo ];
        };
      };
      MIMELiteHTML = perlPkgs.buildPerlPackage {
        pname = "MIME-Lite-HTML";
        version = "1.24";
        src = fetchurl {
          url = mirror://cpan/authors/id/A/AL/ALIAN/MIME-Lite-HTML-1.24.tar.gz;
          sha256 = "db603ccbf6653bcd28cfa824d72e511ead019fc8afb9f1854ec872db2d3cd8da";
        };
        doCheck = false;
        propagatedBuildInputs = [ HTMLParser LWP MIMELite URI ];
        meta = {
          description = "Provide routine to transform a HTML page in a MIME-Lite mail";
          license = with lib.licenses; [ artistic1 gpl1Plus ];
        };
      };
    };

    nixpkgs.overlays = [
      (self: super: {
        sympa = pkgs.callPackage ../packages/sympa { };
      })
    ];
  };
}
