#!/bin/sh

# KUSANAGI Maintenance Window Script
# 2018.04.19 Ver.1.10 Akira Tsumura @ LittleBits,LLC.
# https://github.com/atsumura1130/magatama/tree/master/autoupdate

#---
# Configure
CFG_FILE='/root/bin/magatama.conf'
if [ -f "$CFG_FILE" ]; then
 # Load Config
 . ${CFG_FILE}
else
 echo "Configraion file not found."
 exit 1;
fi

# CD to Base Dir.
if [ -d "${CFG_BASEDIR}" ]; then
 cd ${CFG_BASEDIR}
else
 echo "Configration Error CFG_BASEDIR."
 exit 1
fi

# ---
# Switch modes
case ${1} in

 # ---
 # Setup - Install Script
 setup)
    echo "# Run sh ./magatama_mw setup | sh"
    # Auto Setup Script
    if [ ! -d "/root/bin" ];then
        echo "mkdir -p /root/bin"
    fi
    echo "cp -prv ./magatama_mw.sh /root/bin/"
    echo "chmod +x /root/bin/magatama_mw.sh"
    echo "# Next - Run magatama_mw.sh, look help."
 ;;

 # ---
 # Init - add crontab
 init)
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
    else
        # Error - Script not found.
        echo 'magatama_mw.sh not found in /root/bin.'
        exit 1
    fi
 ;;

 # ---
 # Reboot - Check success and erase flag file
 reboot)
    if [ -f "${FLG_MW_FN}" ];then
        # Get Status Message
        MSG="${CFG_MW_MSG}"
        MSG_STATUS=`cat ${FLG_MW_FN}`
        # Delete RebootFlag File
        rm ${FLG_MW_FN}
        # Kick notify script.
        if [ -f ./magatama_notify.sh ]; then
            # put MSG and MSG_STATUS
            . ./magatama_notify.sh
        fi
    fi
 ;;

 # Maintemance Window
 maintenance)
    # ForceFlag - Force Run Update
    if [ "$2" = "force" ]; then
        FLG_FORCE=1;
        MSG_STATUS=${CFG_MW_MSG_FORCE}
    fi

    if [ "${FLG_FORCE}" != "1" ];then
        nice ionice yum check-update -q > /dev/null
    fi

    # if retuen code eq 100, have yum-repos updates.
    if [ "$?" -eq "100" -o "${FLG_FORCE}" = "1" ]; then
        # Update KUSANAGI
        yum update -y -q > /dev/null
        if [ "$?" -eq "0" ]; then
            # Make Maintenance flag and write status message.
            touch "${FLG_MW_FN}" && echo "${MSG_STATUS}" > ${FLG_MW_FN}
            # reboot
            sync && sync && sync && shutdown -r now && exit 0
        fi
    else
        # Non-Update
    fi
 ;;

 

 # ---
 # Main
 *)
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
 ;;

# ---
# End of switch modes.
esac

exit 0