{ config, lib, pkgs, ... }:

let
  writeJson = name: tree: pkgs.writeText name (builtins.toJSON tree);
in
{
  users.users.niap = {
    description = "NIA proxy user (no shell, port forwarding only)";
    shell = "${pkgs.shadow}/bin/nologin";
    openssh.authorizedKeys.keys = with import ../ssh-keys.nix; [ ms ln mm ];
  };

  networking.firewall.allowedTCPPorts = [ 80 443 9090 ];

  services.prometheus = let
    exportersCfg = config.services.prometheus.exporters;
    relabelTargets = exporterTarget: [
      {
        source_labels = [ "__address__" ];
        target_label = "__param_target";
      }
      {
        source_labels = [ "__param_target" ];
        target_label = "instance";
      }
      {
        target_label = "__address__";
        replacement = exporterTarget;
      }
    ];
    staticTargets = tgts: [
      {
        targets = tgts;
      }
    ];
    oneStaticTarget = tgt: staticTargets [ tgt ];
    relabelAddressInstance = address: replacement: {
      source_labels = [ "__address__" ];
      target_label = "instance";
      regex = builtins.replaceStrings ["[" "]"] [".?" ".?"] address;
      replacement = replacement;
    };
  in
  {
    enable = true;

    #extraFlags = [ "--web.enable-admin-api" ];
    # delete data with label:
    # curl -X POST -g 'http://83.167.228.98:9090/api/v1/admin/tsdb/delete_series?match[]={instance="localhost:9100"}'

    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" "logind" "processes" ];
      listenAddress = "127.0.0.1";
    };
    # exporters.blackbox =

    globalConfig = {
      scrape_interval = "15s";
      external_labels = {
        monitor = "status";
      };
    };

    alertmanagers = [
      {
        scheme = "http";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.alertmanager.port}" ];
          }
        ];
      }
    ];

    alertmanager = {
      enable = true;
      configuration = {
        global = {
          smtp_smarthost = "mx.otevrenamesta.cz:587";
          smtp_hello = "status.otevrenamesta.cz";
          smtp_from = "status@otevrenamesta.cz";
          smtp_auth_username = "status@otevrenamesta.cz";
          smtp_auth_password = (import ../secrets/status.nix).smtpPassword;
        };
        route = {
          receiver = "ignore";
          group_wait = "30s";
          group_interval = "5m";
          repeat_interval = "4h";
          group_by = [ "alertname" ];

          routes = [
            {
              receiver = "email";
              group_wait = "30s";
              match.severity = "page";
            }
          ];
        };
        receivers = [
          {
            # with no *_config, this will drop all alerts directed to it
            name = "ignore";
          }
          {
            name = "email";
            email_configs = [
              {
                send_resolved = true;
                to = "alert@otevrenamesta.cz";
              }
            ];
          }
        ];
      };
    };

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = oneStaticTarget "localhost:9090";
      }
      {
        job_name = "grafana";
        static_configs = oneStaticTarget "localhost:3000";
      }
      # node collector
      (let
        instances = {
          "localhost:9100"      = "status.otevrenamesta.cz";

          "37.205.14.138:9100"  = "mesta-services";
          "37.205.14.138:10491" = "glpi.otevrenamesta.cz";
          #"37.205.14.138:10591" = "wp.otevrenamesta.cz";
          "37.205.14.138:10791" = "nia.otevrenamesta.cz";
          "37.205.14.138:10991" = "matrix.otevrenamesta.cz";
          #"37.205.14.138:11391" = "redmine.otevrenamesta.cz";

          "37.205.14.17:9100"   = "mesta-libvirt";
          "37.205.14.17:10091"  = "mx.otevrenamesta.cz";
          "37.205.14.17:10191"  = "lists.otevrenamesta.cz";
          "37.205.14.17:10391"  = "navstevnost.otevrenamesta.cz";
          "37.205.14.17:10491"  = "proxy.otevrenamesta.cz";
          "37.205.14.17:10591"  = "wiki.vesp.cz";

          "[2a01:430:17:1::ffff:1309]:9100" = "dsw2.otevrenamesta.cz";
        };
      in {
        job_name = "node";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
      # nginx collector
      (let
        instances = {
          "37.205.14.17:10493" = "proxy.otevrenamesta.cz";
          "[2a01:430:17:1::ffff:1309]:9113" = "dsw2.otevrenamesta.cz";
          "37.205.14.138:10993" = "matrix.otevrenamesta.cz";
        };
      in {
        job_name = "nginx";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
      # nginxlog, currently DSW2 only
      (let
        instances = {
          "[2a01:430:17:1::ffff:1309]:4040" = "dsw2.otevrenamesta.cz";
        };
      in {
        job_name = "nginxlog";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
      # matrix-synapse
      {
        job_name = "synapse";
        metrics_path = "/_synapse/metrics";
        scheme = "https";
        static_configs = oneStaticTarget "matrix.vesp.cz";
      }
      # postfix
      (let
        instances = {
          "37.205.14.17:10094"  = "mx.otevrenamesta.cz";
        };
      in {
        job_name = "postfix";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
      # rspamd
      (let
        instances = {
          "37.205.14.17:10098"  = "mx.otevrenamesta.cz";
        };
      in {
        job_name = "rspamd";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
      # mysql
      (let
        instances = {
          "[2a01:430:17:1::ffff:1309]:9104" = "dsw2.otevrenamesta.cz";
        };
      in {
        job_name = "mysql";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
      # postresql
      (let
        instances = {
          "37.205.14.138:10997" = "matrix.otevrenamesta.cz";
        };
      in {
        job_name = "postgresql";
        static_configs = staticTargets (lib.attrNames instances);
        relabel_configs = lib.mapAttrsToList relabelAddressInstance instances;
      })
    ];

    ruleFiles = [
      # matrix-synapse
      (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/matrix-org/synapse/v1.9.0/contrib/prometheus/synapse-v2.rules";
        sha256 = "0dw05qwnr24hrshp6vmncfbxhzbh1rbbnz0rqkvrjj6qjhzpmfhq";
      })

      # alerting
      (writeJson "alerting.json" {
        groups = [
          {
            name = "system";
            rules = [
              {
                alert = "RootPartitionLowInodes";
                expr = ''node_filesystem_files_free{mountpoint="/"} <= 10000'';
                for = "30m";
                labels.severity = "page";
              }
              {
                alert = "RootPartitionLowDiskSpace";
                expr = ''node_filesystem_avail_bytes{mountpoint="/"} <= 1000000000'';
                for = "30m";
                labels.severity = "page";
              }
              {
                alert = "NodeDown";
                expr = ''up{job="node"} < 1'';
                for = "2m";
                labels.severity = "page";
              }
            ];
          }
        ];
      })

    ];
  };

  services.grafana = {
    enable = true;
    addr = "127.0.0.1"; #TODO
    analytics.reporting.enable = false;
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      "status.otevrenamesta.cz" = {
        forceSSL = true;
        enableACME = true;
        default = true;
        locations."/".proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
      };
    };
  };
}
