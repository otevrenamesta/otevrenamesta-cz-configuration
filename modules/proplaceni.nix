{ config, lib, pkgs, ... }:

with lib;
let
  py3 = pkgs.python3;
  pkg = pkgs.callPackage ../packages/proplaceni.nix { python3 = py3; };
  pyEnv = pkg.passthru.pyEnv;

  cfg = config.services.proplaceni;
  user = "proplaceni";
  group = "proplaceni";
  dataDir = "/var/lib/proplaceni";
  writableSubDirs = [ "static_files" "media_files" "temp_files" "log_files" ];
  manage = pkgs.writeShellScriptBin "manage-proplaceni" ''
    export PYTHONPATH='${dataDir}'
    export DJANGO_SETTINGS_MODULE=mysettings.settings
    ${pkgs.su}/bin/su -s ${pkgs.runtimeShell} -c "${pkg}/manage.py $*" ${user}
  '';
in
{
  options.services.proplaceni = {
    enable = mkEnableOption "Proplaceni";

    configFile = mkOption {
      type = types.path;
      default = ../files/ucto/settings_local.py;
      example = "/run/keys/ucto-settigs_local.py";
      description = ''
        Path to <filename>settings_local.py</filename>.
        You may want to keep it out of nix store if it contains keys and passwords.
      '';
    };

    webHost = mkOption {
      type = types.str;
      description = "Host part of the app root URL.";
      example = "ucto.example.org";
    };

    webLocation = mkOption {
      type = types.str;
      default = "/";
      example = "/ucto";
      description = "Location part of the app URL.";
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ manage ];

    systemd.services.proplaceni = {
      description = "Proplaceni / ucto";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      restartTriggers = [ cfg.configFile ];
      restartIfChanged = true;
      preStart = ''
        ${pkg}/manage.py makemigrations piructo
        ${pkg}/manage.py migrate
        ${pkg}/manage.py collectstatic --no-input
      '';

      environment = {
        PYTHONPATH= "${dataDir}:${pkg}:${pyEnv}/${py3.sitePackages}";
        DJANGO_SETTINGS_MODULE = "mysettings.settings";

        PIROPLACENI_DEBUG = "b-off";
      };

      serviceConfig = {
        Type = "simple";
        User = user;
        Group = group;
        WorkingDirectory = dataDir;
        ExecStart = ''
          ${py3.pkgs.gunicorn}/bin/gunicorn main.wsgi \
            --workers 4 \
            --worker-class gevent \
            --bind unix:/run/proplaceni/gunicorn.sock
        '';

        Restart = "on-failure";
        RestartSec = "2s";
        StartLimitIntervalSec = "30s";

        StateDirectory = "proplaceni";
        StateDirectoryMode = "0550";
        RuntimeDirectory = "proplaceni";
        RuntimeDirectoryMode = "0750";

        # sandboxing options
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateNetwork = true; # remove for --bind with inet socket
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
      };
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.webHost}" = {
        #forceSSL = true;
        #enableACME = true;
        locations."${cfg.webLocation}" = {
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            proxy_redirect off;

            proxy_pass http://unix:/run/proplaceni/gunicorn.sock;
          '';
        };
        locations."${removeSuffix "/" cfg.webLocation}/static/" = {
          alias = "${dataDir}/static_files/";
        };
        locations."${removeSuffix "/" cfg.webLocation}/media/" = {
          alias = "${dataDir}/media_files/";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir}                               0750 ${user} ${group} - -"
      "d ${dataDir}/mysettings                    0750 ${user} ${group} - -"
      "f ${dataDir}/mysettings/__init__.py        0750 ${user} ${group} - -"
      "L+ ${dataDir}/mysettings/settings.py        0750 ${user} ${group} - ${pkg}/main/settings.py"
      "L+ ${dataDir}/mysettings/settings_global.py 0750 ${user} ${group} - ${pkg}/main/settings_global.py"
      "L+ ${dataDir}/mysettings/settings_local.py  0750 ${user} ${group} - ${cfg.configFile}"
    ]
    ++ (map (subDir: "C ${dataDir}/${subDir} 0750 ${user} ${group} - ${pkg}/${subDir}") writableSubDirs);

    users.users."${user}" = {
      group = group;
      home = dataDir;
      isSystemUser = true;
    };

    users.groups."${group}" = { members = [ config.services.nginx.user ]; };
  };
}
