# magatama auto update
KUSANAGI's auto update and reboot utility.

## How to use
- download 'magatama_mw.sh' to KUSANAGI's /root.
- run `sh magatama_mw.sh setup | sh`.
- run `/root/bin/magatama_mw.sh`, show help.

## Options
- setup - show first setup script, pipe to /bin/sh.
- init - init crontab.
- maintenance - check yum repositorys, update, and reboot from crontab. 
- force maintenance - `magatama_mw.sh maintenance force`
- reboot - check rebooted and notify slack(optional).
- (none) - show help.

## How to Slack Notyfy
make `/root/bin/magatama_slack.sh`.
require from maintenance-script, no +w parmission.