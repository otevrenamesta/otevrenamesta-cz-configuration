{ config, pkgs, lib, ... }:
let
  emails = import ../secrets/private-mail.nix;
  hashes = import ../secrets/private-mail-hash.nix;

  ipWhitelist = [
    "192.168.122.101" # relay ML domains to sympa & allow sympa to send outgoing email
    "192.168.122.105" # mediawiki
    "37.205.14.138"   # mesta-services (matrix)
    "185.8.165.109"   # dsw2
  ];
in

{
  imports = [
    # updating simple-nixos-mailserver? make sure submissionOptions below stays in sync
    # fork that enables rspamd web UI, this will likely be part of SNM soon
    (builtins.fetchTarball {
      url = "https://github.com/otevrenamesta/nixos-mailserver/archive/70ec1432187f5a97c6ed2b4614ca4c83a0755e65.tar.gz";
      sha256 = "1vqrbvjf0fxmlg3qc8ggx3k8ha7sqw2gzc0pbhwhprvarx1haqaa";
    })
    ../modules/postfix-report.nix
  ];

  mailserver = {
    enable = true;
    fqdn = "mx.otevrenamesta.cz";
    domains = [ "otevrenamesta.cz" "try.otevrenamesta.cz" "dotace.praha3.cz" ];
    certificateScheme = 3; # use LetsEncrypt, requires vhost on proxy
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

      "noreply@dotace.praha3.cz" = {
        hashedPassword = hashes.dp_;

        #sieveScript = ''
        # redirect "${email.somewhere-else}";
        #'';
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

  # needed so that remote aliases (x@otevrenamesta.cz -> y@seznam.cz) work with strict (-all) SPF policies
  services.postsrsd = {
    enable = true;
    domain = "otevrenamesta.cz";
    excludeDomains = [ "lists.otevrenamesta.cz" ];
    forwardPort = 10001;
    reversePort = 10002;
  };

  services.postfix = {
    networks = map (ip: "${ip}/32") ipWhitelist;
    relayDomains = [ "lists.otevrenamesta.cz" ];
    transport = ''
      lists.otevrenamesta.cz    relay:[192.168.122.101]
    '';
    # aliases for virtual users and mailing lists
    virtual = ''

      # virtual users
      cityvizor@otevrenamesta.cz               ${emails.pk_}, ${emails.ln_}, ${emails.cv_}
      danidel.kolar@otevrenamesta.cz           ${emails.dk_}
      informace@otevrenamesta.cz               info@lists.otevrenamesta.cz
      iot@otevrenamesta.cz                     ${emails.ln_}, ${emails.zg_}
      ladislav.nesnera@otevrenamesta.cz        ${emails.ln_}
      marcel.kolaja@otevrenamesta.cz           ${emails.mk_}
      martin.sebek@otevrenamesta.cz            ${emails.ms_}
      olmr@otevrenamesta.cz                    ${emails.vo_}
      ondrej.profant@otevrenamesta.cz          ${emails.op_}
      pavla.kadlecova@otevrenamesta.cz         ${emails.pk_}

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

    # enable postsrsd integration
    config = {
      sender_canonical_maps = "tcp:localhost:10001";
      sender_canonical_classes = [ "envelope_sender" ];
      recipient_canonical_maps = "tcp:localhost:10002";
      recipient_canonical_classes = [ "envelope_recipient" "header_recipient" ];
    };

    # disable smtpd_sender_restrictions = reject_sender_login_mismatch that SNM adds
    # KEEP THIS IN SYNC W/ submissionOptions IN nixos-mailserver/mail-server/postfix.nix
    submissionOptions = lib.mkForce {
      smtpd_tls_security_level = "encrypt";
      smtpd_sasl_auth_enable = "yes";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "/run/dovecot2/auth";
      smtpd_sasl_security_options = "noanonymous";
      smtpd_sasl_local_domain = "$myhostname";
      smtpd_client_restrictions = "permit_sasl_authenticated,reject";
      smtpd_sender_login_maps = "hash:/etc/postfix/vaccounts";
      #smtpd_sender_restrictions = "reject_sender_login_mismatch";
      smtpd_recipient_restrictions = "reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject";
      cleanup_service_name = "submission-header-cleanup";
    };
  };

  services.rspamd = {
    locals = {
      "options.inc" = { text = ''
        local_addrs = [ ${lib.concatMapStringsSep ", " (ip: ''"${ip}"'' ) ipWhitelist} ];
      ''; };
      "classifier-bayes.conf" = { text = ''
        autolearn = true;
      ''; };
    };
  };

  services.postfix-report = {
    enable = true;
    saslUsername = "noreply@dotace.praha3.cz";
    sshDestination = "maillog@185.8.165.109";
    onCalendar = "2020-4,5,6-* 23:30:00";
  };
}
