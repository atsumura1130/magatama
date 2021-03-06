#!/bin/sh

# MAGATAMA - KUSANAGI 3rdparty utilities.

# magatama_mw - Auto OS Update Script.
# 2018.04.21 Ver.1.10 Akira Tsumura @ LittleBits,LLC.
# https://github.com/atsumura1130/magatama/

#---
# Configure
CFG_FILE='/root/bin/magatama_conf.sh'
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
        if [ ! -d "/root/bin" ]; then
            echo "mkdir -p /root/bin"
        fi
        echo "cp -prv ./magatama_mw.sh /root/bin/"
        echo "chmod +x /root/bin/magatama_mw.sh"
        echo "# Next - Run magatama_mw.sh, look help."
    ;;

    # ---
    # Init - add crontab
    init)
            # Check magatama_mw script in /root/bin
            if [ -f "/root/bin/magatama_mw.sh" ]; then
            # Check crontab and insert auto run
            FLG=`crontab -l | grep "magatama_mw.sh" | wc -l`
                if [ "${FLG}" = "0" ]; then
                    (crontab -l ;\
                        echo "# magatama_mw - Kick OS Auto Updater" ;\
                        echo "@reboot /root/bin/magatama_mw.sh reboot" ;\
                        echo "00 03 * * *  /root/bin/magatama_mw.sh maintenance" ;\
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
        if [ -f "${FLG_MW_FN}" ]; then
            # Get Status Message
            MSG=${CFG_MW_MSG}
            MSG_STATUS=`cat ${FLG_MW_FN}`

            # Delete RebootFlag File
            rm ${FLG_MW_FN}

            # Run Post update script
            if [ -f "/root/bin/magatama_mw_post.sh" ]; then
                /root/bin/magatama_mw_post.sh
			fi
            # Error Handring
            if [ "${?}" -ne "0" ]; then
                # Notify Error.
                MSG=${CFG_MW_MSG}
                MSG_STATUS=${CFG_MW_MSG_ERR_POST}
                if [ -f ./magatama_notify.sh ]; then
                    . ./magatama_notify.sh
                fi
                exit 1
            fi

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
        if [ "${2}" = "force" ]; then
            FLG_DRY=0;
            FLG_FORCE=1;
        fi

        if [ "${2}" = "dry-run" ]; then
            FLG_DRY=1;
            FLG_FORCE=0;
        fi

		# Get yum check-update result.
        if [ "${FLG_FORCE}" != "1" -a "${FLG_DRY}" != "1" ]; then
            nice ionice yum check-update -q > /dev/null
        fi

        # if retuen code eq 100, have yum-repos updates.
        if [ "${?}" -eq "100" -o "${FLG_FORCE}" = "1" -o "${FLG_DRY}" = "1" ]; then

            if [ "${FLG_DRY}" = "1" ]; then
                # ---
                # is Dry-Run
                MSG=${CFG_MW_MSG}
                MSG_STATUS=${CFG_MW_MSG_DRYRUN}
                if [ -f ./magatama_notify.sh ]; then
                    . ./magatama_notify.sh
                fi
                exit 0

            else
                # ---
                # is Update

                # Run Pre update script
                if [ -f "/root/bin/magatama_mw_pre.sh" ]; then
                    /root/bin/magatama_mw_pre.sh
                fi

                # Error Handring
                if [ "${?}" -ne "0" ]; then
                    # Notify Error.
                    MSG=${CFG_MW_MSG}
                    MSG_STATUS=${CFG_MW_MSG_ERR_PRE}
                    if [ -f ./magatama_notify.sh ]; then
                        # put MSG and MSG_STATUS
                        . ./magatama_notify.sh
                    fi
                    exit 1
                fi
                
                # Update KUSANAGI
                yum update -y -q > /dev/null
                if [ "${?}" -eq "0" ]; then
                    # Make Maintenance flag and write status message.
                    touch "${FLG_MW_FN}" && echo "${CFG_MW_MSG_MAINTENANCE}" > ${FLG_MW_FN}
                    # reboot
                    sync && sync && sync && shutdown -r now && exit 0
                fi
            fi
        fi
    ;;

    # ---
    # show Help - default
    *)
        # Must Double-quort.
        echo "${CFG_MW_HELP}"
    ;;

# ---
# End of switch modes.
esac

exit 0
