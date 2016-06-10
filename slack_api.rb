require "httparty"
require "./token.rb"

sender = ""
reciever = ""
data = {
  channel: "#plock_recommendations",
  username: "Plock!",
  text: "#{sender} recommended a link to #{reciever}! View it <https://www.theironyard.com|here!> ",
  icon_emoji: ":aardworf:"
}
HTTParty.post "https://hooks.slack.com/services/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",
  body: {
    payload: data.to_json
  }
