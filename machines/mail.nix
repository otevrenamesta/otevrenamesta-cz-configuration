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
                "info@try.otevrenamesta.cz"
                "postmaster@otevrenamesta.cz"
            ];
        };

        "info2@try.otevrenamesta.cz" = {
            hashedPassword = "$6$z2nge7lfKTc2p0uH$8dToEqj6AMu5cNaNtDu8aJ3p/bO.mBO2L1D6kTKfYPa/uLViSXIXiyPwIgR33K3oxk/1MGgvIFKNu9.Dlw1O/.";

            sieveScript = '' 
                 redirect "nesnera@email.cz";
            ''; 
        };
    };

    extraVirtualAliases = {
        # address = forward address;
        #"abuse@try.otevrenamesta.cz" = "user1@try.otevrenamesta.cz";
    };

    ## this was needed when sympa was hosting lists on @try.otevrenamesta.cz
    #policydSPFExtraConfig = ''
    #  Whitelist = 192.168.122.101/32
    #'';
  };

  services.postfix = {
    # relay ML domains to sympa & allow sympa to send outgoing email
    networks = [ "192.168.122.101/32" ];
    relayDomains = [ "lists.otevrenamesta.cz" ];
    transport = ''
      lists.otevrenamesta.cz    relay:[192.168.122.101]
    '';
    # aliases for mailing lists
#    virtual = ''
#      wwwybor@try.otevrenamesta.cz  wwwybor@lists.try.otevrenamesta.cz
#      vratnice@try.otevrenamesta.cz vratnice@lists.try.otevrenamesta.cz
#      ustredna@try.otevrenamesta.cz ustredna@lists.try.otevrenamesta.cz
#    '';
  };
}
