{ config, pkgs, ... }:
let
  emails = import ../secrets/private-mail.nix;
  hashes = import ../secrets/private-mail-hash.nix;

in

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
    domains = [ "otevrenamesta.cz" "try.otevrenamesta.cz"];
    loginAccounts = {

      ## domain @otevrenamesta.cz:
      "projekty@otevrenamesta.cz" = {
          hashedPassword = "${hashes.pp_}";
      };
      "universal@otevrenamesta.cz" = {
          hashedPassword = "${hashes.uu_}";
      };
      "user1@otevrenamesta.cz" = {
          hashedPassword = "${hashes.tt_}";

          aliases = [
              "userX@otevrenamesta.cz"
          ];
      };
      "user2@otevrenamesta.cz" = {
          hashedPassword = "${hashes.tt_}";

          sieveScript = '' 
               redirect "${emails.ln_}";
               redirect "${emails.lng_}";
          ''; 
      };

      ## domain @try.otevrenamesta.cz:
      "user1@try.otevrenamesta.cz" = {
          hashedPassword = "${hashes.tt_}";

          aliases = [
              "userX@try.otevrenamesta.cz"
              "userY@try.otevrenamesta.cz"
          ];
      };
      "user2@try.otevrenamesta.cz" = {
          hashedPassword = "${hashes.tt_}";
      };
      "user3@try.otevrenamesta.cz" = {
          hashedPassword = "${hashes.tt_}";
      };
      "info2@try.otevrenamesta.cz" = {
          hashedPassword = "${hashes.tt_}";

          sieveScript = '' 
               redirect "${emails.ln_}";
               redirect "${emails.lnl_}";
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
    # aliases for virtual users and mailing lists
    virtual = ''

      # virtual users
      cityvizor@otevrenamesta.cz               ${emails.pk_}, ${emails.ln_}
      danidel.kolar@otevrenamesta.cz           ${emails.dk_}
      informace@otevrenamesta.cz               info@lists.otevrenamesta.cz
      iot@otevrenamesta.cz                     ${emails.ln_}, ${emails.zg_}
      ladislav.nesnera@otevrenamesta.cz        ${emails.lng_}
      marcel.kolaja@otevrenamesta.cz           ${emails.mk_}
      martin.sebek@otevrenamesta.cz            ${emails.ms_}
      ondrej.profant@otevrenamesta.cz          ${emails.op_}
      pavla.kadlecova@otevrenamesta.cz         ${emails.pk_}
      user.seznam@otevrenamesta.cz             ${emails.ln_}, ${emails.lng_}

      # virtual lists
      listmaster@otevrenamesta.cz              listmaster@lists.otevrenamesta.cz

      sympa@otevrenamesta.cz                   sympa@lists.otevrenamesta.cz
      sympa-request@otevrenamesta.cz           sympa-request@lists.otevrenamesta.cz
      sympa-owner@otevrenamesta.cz             sympa-owner@lists.otevrenamesta.cz
      
      info@otevrenamesta.cz                    info@lists.otevrenamesta.cz
      info-request@otevrenamesta.cz            info-request@lists.otevrenamesta.cz
      info-editor@otevrenamesta.cz             info-editor@lists.otevrenamesta.cz
      info-owner@otevrenamesta.cz              info-owner@lists.otevrenamesta.cz
      info-subscribe@otevrenamesta.cz          info-subscribe@lists.otevrenamesta.cz
      info-unsubscribe@otevrenamesta.cz        info-unsubscribe@lists.otevrenamesta.cz
      
      konference@otevrenamesta.cz              konference@lists.otevrenamesta.cz
      konference-request@otevrenamesta.cz      konference-request@lists.otevrenamesta.cz
      konference-editor@otevrenamesta.cz       konference-editor@lists.otevrenamesta.cz
      konference-owner@otevrenamesta.cz        konference-owner@lists.otevrenamesta.cz
      konference-subscribe@otevrenamesta.cz    konference-subscribe@lists.otevrenamesta.cz
      konference-unsubscribe@otevrenamesta.cz  konference-unsubscribe@lists.otevrenamesta.cz
      
      testforum@otevrenamesta.cz               testforum@lists.otevrenamesta.cz
      testforum-request@otevrenamesta.cz       testforum-request@lists.otevrenamesta.cz
      testforum-editor@otevrenamesta.cz        testforum-editor@lists.otevrenamesta.cz
      testforum-owner@otevrenamesta.cz         testforum-owner@lists.otevrenamesta.cz
      testforum-subscribe@otevrenamesta.cz     testforum-subscribe@lists.otevrenamesta.cz
      testforum-unsubscribe@otevrenamesta.cz   testforum-unsubscribe@lists.otevrenamesta.cz
      
      vybor@otevrenamesta.cz                   vybor@lists.otevrenamesta.cz
      vybor-request@otevrenamesta.cz           vybor-request@lists.otevrenamesta.cz
      vybor-editor@otevrenamesta.cz            vybor-editor@lists.otevrenamesta.cz
      vybor-owner@otevrenamesta.cz             vybor-owner@lists.otevrenamesta.cz
      vybor-subscribe@otevrenamesta.cz         vybor-subscribe@lists.otevrenamesta.cz
      vybor-unsubscribe@otevrenamesta.cz       vybor-unsubscribe@lists.otevrenamesta.cz
    '';
  };
}
