require "httparty"
require "./token.rb"
require "plock.rb"

# link = "https://slack.com/api/"

def user name, password
  User.find_by(username: name, password: password)
end
u = user params[:username], params[:password]


#now all this needs is for slack to get the created_by and sending_to
curl -X POST --data-urlencode 'payload={
"channel": "#plock_recommendations",
"username": "Plock!",
"text": " recommended a link to you! View it <https://www.theironyard.com/|here!> ",
"icon_emoji": ":aardwolf:"
}'
https://hooks.slack.com/services/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
