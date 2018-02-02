{ config, pkgs, lib ? pkgs.lib, ... }:

with lib;

let

  cfg = config.services.ckan;
  debugStr = if cfg.debug then "true" else "false";
  gunicornLogLevel = if cfg.debug then "debug" else "info";
  baseDir = "/var/lib/ckan";
  solrDir = "/var/lib/ckan/solr/";

  ckanConf = pkgs.substituteAll {
    src = ./support/ckanconfig.ini;
    plugins = concatStringsSep " " cfg.enabledPlugins;
    inherit baseDir;
    inherit debugStr;
    inherit (cfg) ckanURL localeDefault extraConfig;
  };

  whoIni = pkgs.substituteAll {
    src = ./support/who.ini;
  };

  ckanPreStart = ''
    #!${pkgs.stdenv.shell} -eu
    mkdir -p ${baseDir}
    chmod 0750 ${baseDir}
    chown ckan:ckan ${baseDir}

    mkdir -p ${baseDir}/data/{storage,uploads}
    chown -R ckan:ckan ${baseDir}/data

    # translations needs to end up in writable dir otherwise we get exceptions
    mkdir -p ${baseDir}/i18n
    for f in ${ckanPackage}/${pkgs.python.sitePackages}/ckan/i18n/*; do
      cp -R $f ${baseDir}/i18n/
    done

    ln -sf ${ckanConf} ${baseDir}/ckan.ini

    # use make-config to obtain generated.ini so we can get uuid and session secret from it
    if ! [ -e ${baseDir}/generated.ini ]; then
      ${cfg.package}/bin/paster make-config ckan ${baseDir}/generated.ini
    fi

    sessionKey="$( grep 'beaker.session.secret' ${baseDir}/generated.ini | cut -d'=' -f2 )"
    uuid="$( grep 'app_instance_uuid' ${baseDir}/generated.ini | cut -d'=' -f2 )"

    # production config is copied to development.ini so
    # we don't need to pass -c to every paster command
    cp -f ${baseDir}/ckan.ini ${baseDir}/development.ini

    # substitue keys from generated.ini
    sed -i "s~\s\''${app_instance_secret}~$sessionKey~" ${baseDir}/development.ini
    sed -i "s~\s\''${app_instance_uuid}~$uuid~" ${baseDir}/development.ini

    ln -sf ${whoIni} ${baseDir}/who.ini

    # paster hacks
    cp -R ${ckanPackage}/${pkgs.python.sitePackages}/*.dist-info ${baseDir}/ckan.egg-info
    echo "Version: master" > ${baseDir}/ckan.egg-info/PKG-INFO

    ${optionalString haveLocalDB ''
      if ! [ -e ${baseDir}/.db-created ]; then
        ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} ${config.services.postgresql.package}/bin/createuser ckan
        ${pkgs.sudo}/bin/sudo -u ${pgSuperUser} ${config.services.postgresql.package}/bin/createdb --owner ckan ckan
        touch ${baseDir}/.db-created
      fi
    ''}

    '';

  ckanInit = pkgs.writeScript "ckan_init" ''
    #!${pkgs.stdenv.shell} -eu
    ${cfg.package}/bin/paster db init
    ${cfg.package}/bin/paster db upgrade

    ${optionalString cfg.createAdmin ''
      echo y | ${cfg.package}/bin/paster sysadmin add ${cfg.adminUser} email=${cfg.adminEmail}  password=${cfg.adminPassword}
    ''}

    '';

  solrConfDir = pkgs.stdenv.mkDerivation {
    name = "solr-conf";
    src = ./support/solr;

    buildCommand = ''
      mkdir -p "$out"
      cp $src/* $out/
    '';
  };

  solrPreStart = ''
    mkdir -p ${solrDir}/collection1/conf/

    # CKAN schema
    ln -sf ${ckanPackage}/${pkgs.python.sitePackages}/ckan/config/solr/schema.xml ${solrDir}/collection1/conf/schema.xml

    for f in ${solrConfDir}/*; do
      ln -sf $f ${solrDir}/collection1/conf/$( basename $f )
    done

    chown -R ckan:ckan ${solrDir}
  '';

  # XXX: knobs here
  gunicornWrapper = pkgs.writeScript "gunicorn-ckan" ''
    #!${pkgs.stdenv.shell} -eu
    ${env}/bin/gunicorn --name ckan \
      -u ckan \
      -g ckan \
      --workers 1 \
      --log-level=${gunicornLogLevel} \
      --pid /run/gunicorn.pid \
      --paste development.ini \
      --bind=0.0.0.0:80 \
      -k gevent
    '';

  localDB = "dbi:Pg:dbname=ckan;user=ckan;";
  haveLocalDB = cfg.dbi == localDB;
  pgSuperUser = config.services.postgresql.superUser;

  #nixpkgs_python = import ../nixpkgs-python/default.nix {};
  nixpkgs_python = (import (pkgs.fetchFromGitHub {
    owner = "garbas";
    repo = "nixpkgs-python";
    rev = "72b162123b0dbdea1d6b1598a2cb2ec4d3df2189";
    sha256 = "1jvx6xl4626zy05i6hv1g5zwr576hnkdzv3f3irlb4c867ww6irr";
  }) {});

  extendedPackage = nixpkgs_python.ckan.withPackages (cfg.extraPluginPackages);
  interpreter = extendedPackage.interpreter;
  ckanPackage = extendedPackage.packages.ckan;

  env = pkgs.python.buildEnv.override {
    extraLibs = with pkgs.pythonPackages; [ gunicorn gevent ]
      ++ (builtins.attrValues extendedPackage.packages);
    ignoreCollisions = true;
  };

in

{
  ###### interface
  options = {
    services.ckan = rec {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run CKAN services.
        '';
      };

      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable debug server on port 3000.

          Equivalent to 'paster serve'
        '';
      };

      dbi = mkOption {
        type = types.str;
        default = localDB;
        example = "dbi:Pg:dbname=hydra;host=postgres.example.org;user=foo;";
        description = ''
          The DBI string for CKAN database connection.
        '';
      };

      package = mkOption {
        type = types.path;
        #default = pkgs.ckan;
        description = "The CKAN package.";
      };

      ckanURL = mkOption {
        type = types.str;
        default = "http://localhost:5000";
        description = ''
          The base URL for the CKAN webserver

          e.g. https://ckan.example.org
        '';
      };

      createAdmin = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Create admin account with adminUser, adminEmail and adminPassword.

          Don't forget to change the password after creation.
        '';
      };

      adminUser = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          Username for admin user.
        '';
      };

     adminEmail = mkOption {
        type = types.str;
        default = "root@localhost";
        description = ''
          Email of the admin user.
        '';
      };

      adminPassword = mkOption {
        type = types.str;
        default = "letmeinandchangeme";
        description = ''
          Password of the admin user (8 chars minimum).

          Don't forget to change the password after creation.
        '';
      };

      enabledPlugins = mkOption {
        type = types.listOf types.str;
        description = "List of enabled plugins";
        default = [
          "stats"
          "text_view"
          "image_view"
          "recline_view"
        ];
      };

      extraPluginPackages = mkOption {
        type = types.attrs;
        default = {};
        description = "Extra packages to be used as CKAN plugins";
      };

      localeDefault = mkOption {
        type = types.str;
        default = "en";
        description = "Default locale";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Extra lines for the CKAN configuration.";
      };

    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    users.extraGroups.ckan = { };

    users.extraUsers.ckan =
      { description = "CKAN";
        group = "ckan";
        createHome = true;
        home = baseDir;
        useDefaultShell = true;
      };

    services.ckan.package = interpreter;

    environment.systemPackages = [ cfg.package ];

    services.redis.enable = true;

    services.solr =
      { enable = true;
        user = "ckan";
        group = "ckan";
        solrHome = solrDir;
      };

    systemd.services.solr =
      { preStart = solrPreStart;
        restartTriggers = [ solrConfDir ];
        serviceConfig =
          { Restart = "always";
            RestartSec = 3;
          };
      };

    systemd.services.ckan-init =
      { wantedBy = [ "multi-user.target" ];
        requires = [ "solr.service" ] ++ optional haveLocalDB "postgresql.service";
        after = [ "solr.service" ] ++ optional haveLocalDB "postgresql.service";
        preStart = ckanPreStart;

        serviceConfig =
          { PermissionsStartOnly = true;
            ExecStart = ckanInit;
            Type = "oneshot";
            RemainAfterExit = true;
            WorkingDirectory = baseDir;
          };
      };

    systemd.services.ckan-rq =
      { wantedBy = [ "multi-user.target" ];
        after = [ "ckan-init.service" ];
        restartTriggers = [ ckanConf ];
        serviceConfig =
          { ExecStart = "${cfg.package}/bin/paster jobs worker default";
            User = "ckan";
            Type = "simple";
            WorkingDirectory = baseDir;
          };
      };

    systemd.services.ckan-debug-server = mkIf cfg.debug
      { wantedBy = [ "multi-user.target" ];
        after = [ "ckan-init.service" ];
        restartTriggers = [ ckanConf ];
        serviceConfig =
          { ExecStart = "${cfg.package}/bin/paster serve development.ini";
            User = "ckan";
            Type = "simple";
            WorkingDirectory = baseDir;
          };
      };

    systemd.services.ckan-gunicorn = mkIf (!cfg.debug)
      { wantedBy = [ "multi-user.target" ];
        after = [ "ckan-init.service" ];
        restartTriggers = [ ckanConf ];
        restartIfChanged = true;

        serviceConfig = {
          Type = "simple";
          PrivateTmp = true;
          ExecStart = gunicornWrapper;
          WorkingDirectory = baseDir;
        };
      };

    networking.firewall = {
      allowedTCPPorts = optionals (!cfg.debug) [ 80 ] ++ optionals cfg.debug [ 5000 ];
    };

    services.postgresql.enable = mkIf haveLocalDB true;
    services.postgresql.authentication = optionalString haveLocalDB
      ''
         local   all             all                                     trust
         host    all             all             127.0.0.1/32            trust
         host    all             all             ::1/128                 trust
      '';

  };
}


