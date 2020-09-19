{ config, lib, pkgs, ... }:

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
          "37.205.14.138:10591" = "wp.otevrenamesta.cz";
          "37.205.14.138:10791" = "nia.otevrenamesta.cz";
          "37.205.14.138:10991" = "matrix.otevrenamesta.cz";
          "37.205.14.138:11391" = "redmine.otevrenamesta.cz";

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
        };
      in {
        job_name = "nginx";
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
    ];

    rules = [
      (builtins.readFile (pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/matrix-org/synapse/v1.9.0/contrib/prometheus/synapse-v2.rules"; 
        sha256 = "0dw05qwnr24hrshp6vmncfbxhzbh1rbbnz0rqkvrjj6qjhzpmfhq";
      }))
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
