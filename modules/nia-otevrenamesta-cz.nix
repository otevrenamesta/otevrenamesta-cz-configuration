{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nia-otevrenamesta-cz;
  pkg = import ../packages/nia-otevrenamesta-cz { inherit pkgs; };
  baseDir = "/var/lib/nia-otevrenamesta-cz";
  user = "nia";
  group = "nia";

in
{
  options = {
    services.nia-otevrenamesta-cz = {
      enable = mkEnableOption "nia.otevrenamesta.cz";

      hostName = mkOption {
        type = types.str;
        default = "nia.otevrenamesta.cz";
        description = ''
          Host name where this application is going to be served.

          Creates nginx vhost which you can further modify under
          <option>services.nginx.virtualHosts."$${hostName}"</option>
        '';
      };

      configFile = mkOption {
        type = types.path;
        example = "/run/keys/nia-config.php";
        description = ''
          Path to the file that will be used as <filename>config/app.php</filename>.
        '';
      };

      privateKeyFile = mkOption {
        type = types.path;
        example = "/run/keys/private.key";
        description = ''
          Path to the file that will be used as <filename>config/private.key</filename>.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    services.phpfpm.pools.nia-otevrenamesta-cz = {
      inherit user;
      settings = mapAttrs (name: mkDefault) {
        "listen.owner" = "nginx";
        "listen.group" = "nginx";
        "listen.mode" = "0600";
        "pm" = "dynamic";
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
      };
      phpEnv = {
        "APPDIR_LOGS" = "${baseDir}/logs";
        "APPDIR_TMP" = "${baseDir}/tmp";
        "APPDIR_CACHE" = "${baseDir}/tmp/cache";
        "APPDIR_CONFIG" = "${baseDir}/config";
      };
    };

    services.nginx.enable = true;
    services.nginx.virtualHosts.${cfg.hostName} = {
      root = "${pkg}/webroot";

      locations."/" = {
        index = "index.php";
        tryFiles = "$uri $uri/ /index.php?$args";
      };

      locations."~ \\.php$" = {
        extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.nia-otevrenamesta-cz.socket};
          fastcgi_index index.php;
        '';
      };
    };

    users.users.${user} = {
      inherit group;
      home = baseDir;
      isSystemUser = true;
    };

    users.groups.${group} = {};

    systemd.tmpfiles.rules = let
      writable = [ "logs" "tmp" "tmp/cache" "tmp/cache/models" "tmp/cache/persistent" "tmp/cache/views" "tmp/sessions" "tmp/tests" ];
    in
    [
      "d  ${baseDir}                     0511 ${user} ${group} - -"
      "C  ${baseDir}/config              -    -       -        - ${pkg}/config"
      "L+ ${baseDir}/config/app.php      -    -       -        - ${cfg.configFile}"
      "L+ ${baseDir}/config/private.key  -    -       -        - ${cfg.privateKeyFile}"
    ] ++ (flip map writable (d:
      "d  ${baseDir}/${d}                0700 ${user} ${group} - -"
    ));

  };
}
