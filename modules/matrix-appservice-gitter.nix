{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.matrix-appservice-gitter;
  pkg = pkgs.callPackage ../packages/matrix-appservice-gitter { };

in
{
  ##### interface

  options = {

    services.matrix-appservice-gitter = {
      enable = mkEnableOption "Matrix <--> Gitter bridge";

      configFile = mkOption {
        type = types.path;
        description = ''
          Configuration file.

          See <link xlink:href="https://github.com/matrix-org/matrix-appservice-gitter/blob/develop/config/gitter-config-sample.yaml" /> for an example.
        '';
      };

      registrationFile = mkOption {
        type = types.path;
        description = ''
          Registration file used to connect to matrix homeserver.
        '';
      };
    };

  };

  ##### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkg ];

    systemd.services.matrix-appservice-gitter = {
      description = "Matrix <--> Gitter bridge";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        #ExecStart = "${pkg}/bin/matrix-appservice-gitter --config ${configFile} --file ${registrationFile}"; #XXX -p?
        ExecStart = "${pkg}/bin/matrix-appservice-gitter --config ${cfg.configFile}";

        DynamicUser = true;
        User = "matrix-appservice-gitter";
        Group = "matrix-appservice-gitter";

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
  };
}
