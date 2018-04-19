#!/bin/sh

# KUSANAGI Maintenance Window Script
# 2018.04.18 Ver.1.00 Akira Tsumura @ LittleBits,LLC.
# https://github.com/atsumura1130/magatama/tree/master/autoupdate

#---
# Configure
FLG_FN="/root/.magatama.mw"
HOSTNAME=`hostname`
MSG="${HOSTNAME} OS Update Success.(Maintenance Window)"

# --
# Setup - Install Script
if [ "$1" = "setup" ]; then
 echo "# Run sh ./magatama_mw setup | sh"
 # Auto Setup Script
 if [ ! -d "/root/bin" ];then
  echo "mkdir -p /root/bin"
 fi
 echo "cp -prv ./magatama_mw.sh /root/bin/"
 echo "chmod +x /root/bin/magatama_mw.sh"

 echo "# Next - Run magatama_mw.sh, look help."
 exit 0
fi

# --
# Init - add crontab
if [ "$1" = "init" ]; then
 # Check magatama_mw script in /root/bin
 if [ -f "/root/bin/magatama_mw.sh" ]; then
 
  # Check crontab and insert auto run
  FLG=`crontab -l | grep "magatama_mw.sh" | wc -l`
  if [ "${FLG}" = "0" ];then
   (crontab -l ;\
    echo "@reboot /root/bin/magatama_mw.sh reboot" ;\
    echo "00 03 * * *  /root/bin/magatama_mw.sh" ;\
   ) | crontab - 
  fi
  echo "Init succsess - check your crontab."
  echo "---"
  crontab -l
  echo "---"
  exit 0
 else
  echo 'magatama_mw.sh not found in /root/bin.'
  exit 1
 fi
fi


# ---
# Reboot - Check success and erase flag file
if [ "$1" = "reboot" ];then
 if [ -f "${FLG_FN}" ];then
  # Reboot success
  # Delete RebootFlag File
  rm ${FLG_FN}
  # Kick notify script.
  if [ -f /root/bin/magatama_notify.sh ]; then
   . /root/bin/magatama_notify.sh
  fi
 fi
 exit 0
fi

# ---
# Maintemance Window
if [ "$1" = "maintenance" ];then
 if [ "$2" = "force" ]; then
  FLG_FORCE=1;
 fi

 if [ "${FLG_FORCE}" != "1" ];then
  nice ionice yum check-update -q > /dev/null
 fi
 # if retuen code eq 100, begin KUSANAGI updates.
 # ForceFlag - Force Run Update
 if [ "$?" -eq "100" -o "${FLG_FORCE}" = "1" ]; then
 # Update KUSANAGI
  yum update -y -q > /dev/null
  if [ "$?" -eq "0" ]; then
   # Make Maintenance flag
   touch "${FLG_FN}"
   # reboot
   sync && sync && sync && shutdown -r now && exit 0
  fi
 else
  # Non-Update
  exit 0
 fi
fi

# ---
# Main
cat <<_EOL
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
_EOL
exit 0

