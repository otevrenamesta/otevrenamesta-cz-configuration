{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-appservice-slack;
  pkg = pkgs.callPackage ../packages/matrix-appservice-slack { };

in
{
  ##### interface

  options = {

    services.matrix-appservice-slack = {
      enable = mkEnableOption "Matrix <--> Slack bridge";

      configFile = mkOption {
        type = types.path;
        description = ''
          Configuration file.

          See <link xlink:href="https://github.com/matrix-org/matrix-appservice-slack/blob/develop/config/config-sample.yaml" /> for an example.
        '';
      };

      registrationFile = mkOption {
        type = types.path;
        description = ''
          Registration file used to connect to matrix homeserver.
        '';
      };

      matrixPort = mkOption {
        type = types.port;
        default = 6788;
        description = ''
          Port to listen on for connections from Matrix Homeserver;
        '';
      };

      database = {
        user = mkOption {
          type = types.str;
          description = ''
            Database user. Currently only used by createLocally.
          '';
        };

        name = mkOption {
          type = types.str;
          description = ''
            Database name. Currently only used by createLocally.
          '';
        };

        createLocally = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable local PostgreSQL and create user and database.
          '';
        };
      };
    };
  };

  ##### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    systemd.services.matrix-appservice-slack = {
      description = "Matrix <--> Slack bridge";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkg}/bin/matrix-appservice-slack --config ${cfg.configFile} --file ${cfg.registrationFile} --port ${toString cfg.matrixPort}";

        DynamicUser = true;
        User = "matrix-appservice-slack";
        Group = "matrix-appservice-slack";

        StateDirectory = "matrix-appservice-slack";
        WorkingDirectory = "/var/lib/matrix-appservice-slack";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };

    services.postgresql = mkIf cfg.db.createLocally {
      enable = true;
      ensureDatabases = [ cfg.db.name ];
      ensureUsers = [{
        name = cfg.db.user;
        ensurePermissions = {
          "DATABASE ${cfg.db.name}" = "ALL PRIVILEGES";
        };
      }];
    };
  };
}
