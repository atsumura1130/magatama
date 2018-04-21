#!/bin/sh

# MAGATAMA - KUSANAGI 3rdparty utilities.

# Magatama Configuration File
# 2018.04.21 Ver.1.10 Akira Tsumura @ LittleBits,LLC.
# https://github.com/atsumura1130/magatama/

# Global Config
CFG_BASEDIR='/root/bin'
CFG_HOSTNAME=`hostname`

# Status File
FLG_MW_FN="/root/.magatama_mw.tmp"

# Config - AutoUpdate
CFG_MW_MSG="${CFG_HOSTNAME} Maintenance Window Update."
CFG_MW_MSG_MAINTENANCE="Auto Update Succeess."
CFG_MW_MSG_FORCE="Manual Force Update"
CFG_MW_MSG_DRYRUN="Dry-Run"
CFG_MW_MSG_ERR_POST="Post-update script error."
CFG_MW_MSG_ERR_PRE="Pre-update script error."

CFG_MW_HELP="
KUSANAGI support scripts 'Magatama'
maintenance-window - auto update script

* Easy Setup
1. put magatama_mw.sh in /root from GitHUB.
2. run 'sh ./magatama_mw.sh setup | sh'
3. run '/root/bin/magatama_mw.sh init'
4. adjust maintenance window(crontab)
   run 'crontab -e'
5. force update and reboot test.
   run '/root/bin/magatama_mw.sh maintenance force'
"
