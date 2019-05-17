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
    fqdn = "mx.otevrenamesta.cz";
    domains = [ "try.otevrenamesta.cz" ];
    loginAccounts = {
        "user1@try.otevrenamesta.cz" = {
            hashedPassword = "$6$z2nge7lfKTc2p0uH$8dToEqj6AMu5cNaNtDu8aJ3p/bO.mBO2L1D6kTKfYPa/uLViSXIXiyPwIgR33K3oxk/1MGgvIFKNu9.Dlw1O/.";

            aliases = [
                "info@otevrenamesta.cz"
                "postmaster@otevrenamesta.cz"
            ];
        };
    };
  };
}
