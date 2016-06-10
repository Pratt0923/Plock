require "httparty"
require "./token.rb"
# link = "https://slack.com/api/"

#now all this needs is for slack to get the created_by and sending_to
curl -X POST --data-urlencode 'payload={
"channel": "#plock_recommendations",
"username": "Plock!",
"text": "CREATED_BY_PERSON recommended a link to SENDING_TO_PERSON! View it <https://www.theironyard.com/|here!> ",
"icon_emoji": ":aardwolf:"
}'
https://hooks.slack.com/services/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
