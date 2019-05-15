{ config, pkgs, ... }:

{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/v2.2.1/nixos-mailserver-v2.2.1.tar.gz";
      sha256 = "03d49v8qnid9g9rha0wg2z6vic06mhp0b049s3whccn1axvs2zzx";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.otevrenamesta.cz";
    domains = [ "try.otevrenamesta.cz" ];
    loginAccounts = {
        "user1@otevrenamesta.cz" = {
            hashedPassword = "$6$/z4n8AQl6K$kiOkBTWlZfBd7PvF5GsJ8PmPgdZsFGN1jPGZufxxr60PoR0oUsrvzm2oQiflyz5ir9fFJ.d/zKm/NgLXNUsNX/";

            aliases = [
                "info@otevrenamesta.cz"
                "postmaster@otevrenamesta.cz"
            ];
        };
    };
  };
}
