{ config, lib, pkgs, ... }:

with lib;
let
  user = "midpoint";
  group = "midpoint";
  dataDir = "/var/lib/midpoint";
  dist = builtins.fetchTarball {
    url = "https://evolveum.com/downloads/midpoint/4.0/midpoint-4.0-dist.tar.gz";
    sha256 = "1mx4xfnwgwypfwiarib52xzd7hylmj4wk2z9wgv5lplg8w885zal";
  };
  cfg = config.services.midpoint;
  jdk = pkgs.openjdk11_headless;
in
{
  options.services.midpoint = {
    enable = mkEnableOption "midPoint, an Identity Management (IDM) and Identity Governance (IGA) platform";
  };

  config = mkIf cfg.enable {
    #environment.systemPackages = [ dist ];
    #networking.firewall.allowedTCPPorts = [ 8080 ];

    systemd.services.midpoint = {
      description = "Identity Management and Identity Governance platform";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;
        WorkingDirectory = dataDir;
        ExecStart = ''
          ${jdk}/bin/java \
            -Xms2048M \
            -Xmx4096M \
            -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
            -Dpython.cachedir=${dataDir}/tmp \
            -Djavax.net.ssl.trustStore=${dataDir}/keystore.jceks \
            -Djavax.net.ssl.trustStoreType=jceks \
            -Dmidpoint.home=${dataDir} \
            -jar ${dist}/lib/midpoint.war
        '';

        /*
        Restart = "on-failure";
        RestartSec = "2s";
        StartLimitInterval = "30s";
        StartLimitBurst = 5;
        */

        StateDirectory = "midpoint";
        StateDirectoryMode = "0750";

        # sandboxing options
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        # PrivateNetwork = true; # needs network access
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        #MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
      };
    };

    systemd.tmpfiles.rules = [
      "d  ${dataDir}     0750 ${user} ${group} - -"
      "d  ${dataDir}/tmp 0750 ${user} ${group} - -"
    ];

    users.users."${user}" = {
      group = group;
      home = dataDir;
      isSystemUser = true;
    };

    users.groups."${group}" = {};
  };
}
