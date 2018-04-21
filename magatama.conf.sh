#!/bin/sh

# Magatama Configuration File
# KUSANAGI Maintenance 3rdparty utility.
# 2018.04.19 Ver.1.10 Akira Tsumura @ LittleBits,LLC.
# https://github.com/atsumura1130/magatama/

# Global Config
CFG_BASEDIR='/root/bin'
CFG_HOSTNAME=`hostname`

# Status File
FLG_MW_FN="/root/.magatama_mw.tmp"

# Config - AutoUpdate
CFG_MW_MSG="${CFG_HOSTNAME} Maintenance Window Update."
CFG_MW_MSG_Maintenance="Succeess."
CFG_MW_MSG_FORCE="Manual Force Update"
