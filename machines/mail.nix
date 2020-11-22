{ config, pkgs, lib, ... }:
let
  emails = import ../secrets/private-mail.nix;
  hashes = import ../secrets/private-mail-hash.nix;

  ipWhitelist = [
    "192.168.122.101" # relay ML domains to sympa & allow sympa to send outgoing email
    "192.168.122.105" # mediawiki
    "37.205.14.138"   # mesta-services (matrix)
    "185.8.165.109"   # dsw2
    "2a01:430:17:1::ffff:1309" # dsw2 ipv6
  ];
in

{
  imports = [
    # updating simple-nixos-mailserver? make sure submissionOptions below stays in sync
    (
      let
        commit = "c04260cf5e685fc99ccb669654e147f94e3de8a4";
      in
      builtins.fetchTarball {
       url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${commit}/nixos-mailserver-${commit}.tar.gz";
       # And set its hash
       sha256 = "1cfzlfdfiw8347cgi0y4akj528lpwplhdpq3fv5rw7fb1zq2w6ib";
      }
    )
    ../modules/postfix-report.nix
  ];

  mailserver = {
    enable = true;
    enableImap = true;
    enablePop3 = true;
    fqdn = "mx.otevrenamesta.cz";
    domains = [ "otevrenamesta.cz" "try.otevrenamesta.cz" "dotace.praha3.cz" "dotace.praha12.cz" "dotace.praha14.cz" ];
    certificateScheme = 3; # use LetsEncrypt, requires vhost on proxy
    loginAccounts = {

      ## domain @otevrenamesta.cz:
      "projekty@otevrenamesta.cz" = {
          hashedPassword = "${hashes.pp_}";
      };
      "universal@otevrenamesta.cz" = {
          hashedPassword = "${hashes.uu_}";
      };
      # asi nepoužívané
      "forum@otevrenamesta.cz" = {
	  hashedPassword = hashes.forum_;
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

      "dmarc@otevrenamesta.cz" = {
        hashedPassword = hashes.dmarc_;

        sieveScript = ''
          redirect "${emails.mm_}";
        '';
      };

      "webforum@otevrenamesta.cz" = {
	  hashedPassword = "${hashes.webforum_}";
      };

      # Prometheus Alertmanager
      "status@otevrenamesta.cz" = {
          hashedPassword = hashes.status_;
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
        hashedPassword = hashes.dp3_;
      };

      "noreply@dotace.praha12.cz" = {
        hashedPassword = hashes.dp12_;
      };

      "noreply@dotace.praha14.cz" = {
        hashedPassword = hashes.dp14_;
      };
    };
    # aliases for virtual users and mailing lists
    forwards = {
      # virtual users
      "cityvizor@otevrenamesta.cz"        =      [ emails.pk_ emails.ln_ emails.cv_ ];
      "danidel.kolar@otevrenamesta.cz"    =      emails.dk_;
      "informace@otevrenamesta.cz"        =      "info@lists.otevrenamesta.cz";
      "iot@otevrenamesta.cz"              =      [ emails.ln_ emails.zg_ ];
      "jiri.hlavenka@otevrenamesta.cz"    =      emails.jh_;
      "jiri.marek@otevrenamesta.cz"       =      emails.jm_;
      "ladislav.nesnera@otevrenamesta.cz" =      emails.ln_;
      "marcel.kolaja@otevrenamesta.cz"    =      emails.mk_;
      "martin.sebek@otevrenamesta.cz"     =      emails.ms_;
      "olmr@otevrenamesta.cz"             =      emails.vo_;
      "ondrej.profant@otevrenamesta.cz"   =      emails.op_;
      "pavla.kadlecova@otevrenamesta.cz"  =      emails.pk_;
      "stepan.strebl@otevrenamesta.cz"    =      emails.ss_;
      "dsw2@otevrenamesta.cz"             =      "dsw2@lists.otevrenamesta.cz";
      "alert@otevrenamesta.cz"            =      [ emails.mm_ emails.ln_ emails.srk_ ];

      # virtual lists
      "listmaster@otevrenamesta.cz"             = "listmaster@lists.otevrenamesta.cz";

      "sympa@otevrenamesta.cz"                  = "sympa@lists.otevrenamesta.cz";
      "sympa-request@otevrenamesta.cz"          = "sympa-request@lists.otevrenamesta.cz";
      "sympa-owner@otevrenamesta.cz"            = "sympa-owner@lists.otevrenamesta.cz";

      "info@otevrenamesta.cz"                   = "info@lists.otevrenamesta.cz";
      "info-request@otevrenamesta.cz"           = "info-request@lists.otevrenamesta.cz";
      "info-editor@otevrenamesta.cz"            = "info-editor@lists.otevrenamesta.cz";
      "info-owner@otevrenamesta.cz"             = "info-owner@lists.otevrenamesta.cz";
      "info-subscribe@otevrenamesta.cz"         = "info-subscribe@lists.otevrenamesta.cz";
      "info-unsubscribe@otevrenamesta.cz"       = "info-unsubscribe@lists.otevrenamesta.cz";

      "konference@otevrenamesta.cz"             = "konference@lists.otevrenamesta.cz";
      "konference-request@otevrenamesta.cz"     = "konference-request@lists.otevrenamesta.cz";
      "konference-editor@otevrenamesta.cz"      = "konference-editor@lists.otevrenamesta.cz";
      "konference-owner@otevrenamesta.cz"       = "konference-owner@lists.otevrenamesta.cz";
      "konference-subscribe@otevrenamesta.cz"   = "konference-subscribe@lists.otevrenamesta.cz";
      "konference-unsubscribe@otevrenamesta.cz" = "konference-unsubscribe@lists.otevrenamesta.cz";

      "testforum@otevrenamesta.cz"              = "testforum@lists.otevrenamesta.cz";
      "testforum-request@otevrenamesta.cz"      = "testforum-request@lists.otevrenamesta.cz";
      "testforum-editor@otevrenamesta.cz"       = "testforum-editor@lists.otevrenamesta.cz";
      "testforum-owner@otevrenamesta.cz"        = "testforum-owner@lists.otevrenamesta.cz";
      "testforum-subscribe@otevrenamesta.cz"    = "testforum-subscribe@lists.otevrenamesta.cz";
      "testforum-unsubscribe@otevrenamesta.cz"  = "testforum-unsubscribe@lists.otevrenamesta.cz";

      "vybor@otevrenamesta.cz"                  = "vybor@lists.otevrenamesta.cz";
      "vybor-request@otevrenamesta.cz"          = "vybor-request@lists.otevrenamesta.cz";
      "vybor-editor@otevrenamesta.cz"           = "vybor-editor@lists.otevrenamesta.cz";
      "vybor-owner@otevrenamesta.cz"            = "vybor-owner@lists.otevrenamesta.cz";
      "vybor-subscribe@otevrenamesta.cz"        = "vybor-subscribe@lists.otevrenamesta.cz";
      "vybor-unsubscribe@otevrenamesta.cz"      = "vybor-unsubscribe@lists.otevrenamesta.cz";
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
    excludeDomains = [ "lists.otevrenamesta.cz" "dotace.praha3.cz" "dotace.praha12.cz" ];
    forwardPort = 10001;
    reversePort = 10002;
  };

  services.postfix = let
    ipWhitelist4 = builtins.filter (s: !(lib.hasInfix ":" s)) ipWhitelist;
    ipWhitelist6 = builtins.filter (lib.hasInfix ":") ipWhitelist;
  in {
    networks = map (ip: "${ip}/32") ipWhitelist4 ++ map (ip: "[${ip}]") ipWhitelist6;
    relayDomains = [ "lists.otevrenamesta.cz" ];
    transport = ''
      lists.otevrenamesta.cz    relay:[192.168.122.101]
    '';

    # enable postsrsd integration
    config = {
      sender_canonical_maps = "tcp:localhost:10001";
      sender_canonical_classes = [ "envelope_sender" ];
      recipient_canonical_maps = "tcp:localhost:10002";
      recipient_canonical_classes = [ "envelope_recipient" "header_recipient" ];

      # alternatively we can force ipv4 for gmail only:
      # https://serverfault.com/questions/832945/how-to-contact-gmail-team-regarding-block/834161#834161
      smtp_address_preference = "ipv4";
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
      "options.inc".text = ''
        local_addrs = [ ${lib.concatMapStringsSep ", " (ip: ''"${ip}"'' ) ipWhitelist} ];
        dynamic_conf = "/var/lib/rspamd/rspamd_dynamic"; # For allowing to change options in the web UI
      '';
      "classifier-bayes.conf".text = ''
        autolearn = true;
      '';
      "actions.conf".text = ''
        greylist = 4;
        add_header = 6;
        reject = 15;
      '';
      "dkim_signing.conf".text = ''
        enable = false;
      '';
    };

    # settings that enable rspamd web UI, this may eventually become part of SNM
    # (dynamic_conf = ... above too)
    workers.controller = {
      bindSockets = lib.mkAfter [{
        # Use "ssh -L 8080:localhost:11334 youruser@example.com -N" to tunnel this securely to your browser's machine port 8080
        socket = "localhost:11334";
      }];
      extraConfig = ''
        # For not having to enter the password on the command line
        secure_ip = "::1";
        secure_ip = "127.0.0.1";
      '';
    };
  };

  services.postfix-report = {
    enable = true;
    saslUsername = "noreply@dotace.praha3.cz";
    sshDestination = "maillog@185.8.165.109";
    onCalendar = "2020-4,5,6-* 23:30:00";
  };

  # acmeFallbackHost uses ip as Host:, make sure we end up at the AMCE endpoint
  services.nginx.virtualHosts."mx.otevrenamesta.cz".default = true;

  services.prometheus.exporters.postfix = {
    enable = true;
    openFirewall = true;
    showqPath = "/var/lib/postfix/queue/public/showq";
    systemd.enable = true;
  };
  systemd.services.prometheus-postfix-exporter.serviceConfig.SupplementaryGroups = [ "postdrop" ];

  services.prometheus.exporters.rspamd = {
    enable = true;
    openFirewall = true;
  };
}
