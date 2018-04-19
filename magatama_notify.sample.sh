# ---
# Slack Notyfy Sample
# put '/root/bin/magatama_slack.sh', no +x permission.
# Change for your slack bot.

DATA=`echo '{"text":"'${MSG}'('${MSG_STATUS}')"}'`
curl \
 -X POST \
 -H 'Content-type: application/json' \
 --data $"{DATA}"" \
 https://hooks.slack.com/services/XXXXXXXX/Saya-chan_Daisuki \
 > /dev/null

# do not write 'exit'.
