# Filters postfix log for messages sent by given user and copies this log 
# daily to given destination over SSH.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.postfix-report;
in
{
  options.services.postfix-report = {
    enable = mkEnableOption "postfix reports";

    saslUsername = mkOption {
      type = types.str;
      description = "User whose messages to report";
    };

    sshDestination = mkOption {
      type = types.str;
      example = "maillog@somewhere";
      description = "Target argument passed to SSH";
    };

    onCalendar = mkOption {
      type = types.str;
      default = "*-*-* 23:30:00";
      description = "When to send the report";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.postfix-report = {
      description = "otevrenamesta.cz postfix report for ${cfg.saslUsername}";
      script = ''
        JOURNAL_CMD="journalctl --since=-1d -u postfix --no-pager"
        PATTERN="sasl_username=${cfg.saslUsername}"

        IDS=$($JOURNAL_CMD -g "$PATTERN" | egrep -o "[A-F0-9]{10}" | tr '\n' '|' | sed "s/|$//")
        FILENAME="mail-$(date -Idate).log"

        if [ "x$IDS" = "x" ]; then
          ${pkgs.openssh}/bin/ssh ${cfg.sshDestination} "echo 'no matching logs for this time period' > $FILENAME"
          exit 0
        fi

        $JOURNAL_CMD -g "($IDS): " | ${pkgs.openssh}/bin/ssh ${cfg.sshDestination} "cat > $FILENAME"
      '';
    };
    systemd.timers.postfix-report = {
      description = "daily otevrenamesta.cz postfix report for ${cfg.saslUsername}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.onCalendar;
      };
    };
  };
}

