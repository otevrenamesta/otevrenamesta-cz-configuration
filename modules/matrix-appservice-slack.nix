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

        User = "slackbridge";
        Group = "slackbridge";

        StateDirectory = "matrix-appservice-slack";
        # https://github.com/matrix-org/matrix-appservice-slack/pull/415
        WorkingDirectory = "${pkg}/lib/node_modules/matrix-appservice-slack";

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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };

    users.users.slackbridge = {
      group = "slackbridge";
      isSystemUser = true;
    };
    users.groups.slackbridge = { };
  };
}
