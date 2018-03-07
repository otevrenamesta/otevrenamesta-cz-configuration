{ config, pkgs, lib ? pkgs.lib, ... }:

with lib;

let
  cfg = config.services.etl;
  baseDir = "/var/lib/etl/";

  ftpPortsIntervalStart = 2222;
  ftpPortsIntervalEnd = 2225;

  etlConf = pkgs.substituteAll {
    src = ./support/etl.ini;
    deployDir = "${baseDir}/etl/deploy";
    bannedJARsCSV = concatStringsSep "," (map (x: "\"${x}\"")  cfg.bannedJARs);
    inherit (cfg) domain domainURI frontendPort ftpPort logLevel dataDir logDir extraConfig;
    inherit ftpPortsIntervalStart ftpPortsIntervalEnd;
  };

  # XXX: hack around https://github.com/NixOS/mvn2nix-maven-plugin/issues/13
  # until we don't have a proper package we can provide repository and run maven on target
  # also npm install for frontend /o\
  etlGit = pkgs.fetchgit {
    url = "https://github.com/linkedpipes/etl";
    rev = "d446615ac4036944bebbaa945eb40669194823ff";
    sha256 = "0hgf2ffm5vjbk36rc2i78pglpblmwypy6p1arsid7ym3iy4w7h7f";
    deepClone = true;
  };

  etlPreStart = ''
    #!${pkgs.stdenv.shell} -eu
    mkdir -p ${baseDir}
    chmod 0750 ${baseDir}
    chown etl:etl ${baseDir}

    test -f ${baseDir}/etl-installed && exit 0
    rm -rf ${baseDir}/etl
    cp -r ${etlGit} ${baseDir}/etl

    cd ${baseDir}/etl
    mvn ${optionalString cfg.skipTests "-Dmaven.test.skip=true"} -Dmaven.repo.local=${baseDir}/.m2 clean install

    cd ${baseDir}/etl/deploy/frontend
    npm install

    chown -R etl:etl ${baseDir}/etl
    touch ${baseDir}/etl-installed
    '';

  etlInit = pkgs.writeScript "etl_init" ''
    #!${pkgs.stdenv.shell} -eu
    echo "DONE"
    '';

  mkETLService = name: nameValuePair name
    { wantedBy = [ "multi-user.target" ];
       after = [ "etl-init.service" ];
       requires = [ "etl-init.service" ];
       restartTriggers = [ etlConf ];
       restartIfChanged = true;

       serviceConfig = {
         Type = "simple";
         PrivateTmp = true;
         ExecStart = "${pkgs.jdk9}/bin/java -DconfigFileLocation=${etlConf} -jar ${baseDir}/etl/deploy/${name}/${name}.jar";
         WorkingDirectory = baseDir;
         Restart = "always";
         RestartSec = 3;
         User = "etl";
         Group = "etl";
       };
    };

in

{
  ###### interface
  options = {
    services.etl = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run ETL services.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = "lpetl";
        description = ''
          Application domain

          This is used to construct default domain.uri = http://${domain}:${frontendPort}
        '';
      };

      domainURI = mkOption {
        type = types.str;
        default = "http://${cfg.domain}:${cfg.frontendPort}";
        description = ''
          Prefix used to create URI of templates and pipelines, should be dereferencable.
        '';
      };

      skipTests = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Skip tests during build
        '';
      };

      logLevel = mkOption {
        type = types.str;
        default = "INFO";
        example = "DEBUG";
        description = ''
          Application log level

          Either TRACE, DEBUG, INFO, WARN, ERROR.
        '';
      };

      frontendPort = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          Frontend port
        '';
      };

      ftpPort = mkOption {
        type = types.int;
        default = 2221;
        description = ''
          FTP server port
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "${baseDir}/data/";
        description = ''
          Data dir path
        '';
      };

      logDir = mkOption {
        type = types.str;
        default = "${baseDir}/logs/";
        description = ''
          Log dir path
        '';
      };

      bannedJARs = mkOption {
        type = types.listOf types.str;
        default = [
          ".*e-filesFromLocal.*"
          ".*l-filesToLocal.*"
          ".*x-deleteDirectory.*"
        ];
        description = ''
          List of regexp patterns. Every component has an IRI if the IRI match any of
          the listed patterns then attempt to execute such component cause
          pipeline to fail.
          The default value ban components that are working with local resources.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall for frontendPort
        '';
      };

      openFirewallFTP = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall for ftpPort
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines of configuration to append to config
        '';
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    users.extraGroups.etl = { };

    users.extraUsers.etl =
      { description = "LinkedPipes ETL";
        group = "etl";
        createHome = true;
        home = baseDir;
        useDefaultShell = true;
      };


    systemd.services = listToAttrs (
      (map mkETLService [ "executor" "executor-monitor" "storage" ])
      ++ [
        (nameValuePair "etl-init"
          { wantedBy = [ "multi-user.target" ];
            after = [ "network-online.target" ];
            path = [ pkgs.git pkgs.maven pkgs.nodejs ];
            preStart = etlPreStart;
            restartTriggers = [ etlConf ];
            restartIfChanged = true;

            serviceConfig =
              { PermissionsStartOnly = true;
                ExecStart = etlInit;
                Type = "oneshot";
                RemainAfterExit = true;
                WorkingDirectory = baseDir;
                TimeoutStartSec = 600;
                User = "etl";
                Group = "etl";
              };
            })

        (nameValuePair "frontend"
          { wantedBy = [ "multi-user.target" ];
            after = [ "etl-init.service" ];
            requires = [ "etl-init.service" ];
            path = [ pkgs.nodejs ];
            restartTriggers = [ etlConf ];
            restartIfChanged = true;

            serviceConfig =
              { PermissionsStartOnly = true;
                ExecStart = "${pkgs.nodejs}/bin/node server.js";
                Environment = "configFileLocation=${etlConf}";
                Type = "simple";
                WorkingDirectory = "${baseDir}/etl/deploy/frontend";
                Restart = "always";
                RestartSec = 3;
                User = "etl";
                Group = "etl";
              };
            })
      ]);

    networking.firewall = {
      allowedTCPPorts = optionals cfg.openFirewall [ cfg.frontendPort ]
        ++ optionals cfg.openFirewallFTP [ cfg.ftpPort ];
      allowedTCPPortRanges = optionals cfg.openFirewallFTP [ { from = ftpPortsIntervalStart; to = ftpPortsIntervalEnd; } ];
    };
  };
}
