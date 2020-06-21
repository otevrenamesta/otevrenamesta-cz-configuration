{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/mautrix-facebook";
  registrationFile = "${dataDir}/facebook-registration.yaml";
  cfg = config.services.mautrix-facebook;
  settingsFile = pkgs.writeText "mautrix-facebook-settings.json" (builtins.toJSON cfg.settings);

in {
  options = {
    services.mautrix-facebook = {
      enable = mkEnableOption "Mautrix-Facebook Messenger puppeting bridge";

      settings = mkOption rec {
        type = types.attrs;
        apply = recursiveUpdate default;
        default = {
          appservice = rec {
            database = "sqlite:///${dataDir}/mautrix-facebook.db";
            hostname = "127.0.0.1";
            port = 29319;
            address = "http://localhost:${toString port}";
          };

          logging = {
            version = 1;

            formatters.precise.format = "[%(levelname)s@%(name)s] %(message)s";

            handlers.console = {
              class = "logging.StreamHandler";
              formatter = "precise";
            };

            loggers = {
              mau.level = "INFO";
              fbchat.level = "INFO";
              hbmqtt.level = "INFO";

              # prevent tokens from leaking in the logs:
              aiohttp.level = "WARNING";
            };

            # log to console/systemd instead of file
            root = {
              level = "INFO";
              handlers = [ "console" ];
            };
          };
        };
        example = literalExample ''
          {
            homeserver = {
              address = "http://localhost:8008";
              domain = "public-domain.tld";
            };

            bridge.permissions = {
              "example.com" = "user";
              "@admin:example.com" = "admin";
            };
          }
        '';
        description = ''
          <filename>config.yaml</filename> configuration as a Nix attribute set.
          Configuration options should match those described in
          <link xlink:href="https://github.com/tulir/mautrix-facebook/blob/master/mautrix_facebook/example-config.yaml">
          example-config.yaml</link>.
        '';
      };

      serviceDependencies = mkOption {
        type = with types; listOf str;
        default = optional config.services.matrix-synapse.enable "matrix-synapse.service";
        description = ''
          List of Systemd services to require and wait for when starting the application service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mautrix-facebook = {
      description = "Matrix-Facebook Messenger puppeting bridge";

      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ] ++ cfg.serviceDependencies;
      after = [ "network-online.target" ] ++ cfg.serviceDependencies;

      preStart = ''
        # generate the appservice's registration file if absent
        if [ ! -f '${registrationFile}' ]; then
          cp ${settingsFile} ${dataDir}/config.yaml
          chmod 640 ${dataDir}/config.yaml
          ${pkgs.mautrix-facebook}/bin/mautrix-facebook \
            --generate-registration \
            --base-config='${pkgs.mautrix-facebook}/lib/python3.7/site-packages/mautrix_facebook/example-config.yaml' \
            --config='${dataDir}/config.yaml' \
            --registration='${registrationFile}'
        fi

        # run automatic database init and migration scripts
        ${pkgs.mautrix-facebook.alembic}/bin/alembic -x config='${dataDir}/config.yaml' upgrade head
      '';

      serviceConfig = {
        Type = "simple";
        Restart = "always";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;

        DynamicUser = true;
        PrivateTmp = true;
        WorkingDirectory = pkgs.mautrix-facebook; # necessary for the database migration scripts to be found
        StateDirectory = baseNameOf dataDir;
        UMask = 0027;

        ExecStart = ''
          ${pkgs.mautrix-facebook}/bin/mautrix-facebook \
            --config='${dataDir}/config.yaml'
        '';
      };
    };
  };
}
