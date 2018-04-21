# ---
# MAGATAMA common script.
# Slack Notyfy Sample
# put '/root/bin/magatama_slack.sh', no +x permission.
# Change for your slack bot.

# Configure
SLACK_API="https://hooks.slack.com/services/XXXXXXXX/Saya-chan_Daisuki"
DATA=`echo '{"text":"'${MSG}'('${MSG_STATUS}')"}'`

# Post comment.
curl \
 -X POST \
 -H 'Content-type: application/json' \
 --data "${DATA}" \
 ${SLACK_API} \
 > /dev/null

# do not 'exit'.
