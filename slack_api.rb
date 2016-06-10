require "httparty"
require "./token.rb"


#post to plock_recommendations with webhookbot.
curl -X POST --data-urlencode
'payload={
"channel": "#plock_recommendations",
"username": "webhookbot",
"text": "This is posted to #plock_recommendations and comes from a bot named webhookbot."
}'
https://hooks.slack.com/services/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
