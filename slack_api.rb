require "httparty"
require "./token.rb"

who = "A person"
data = {
  channel: "#plock_recommendations",
  username: "Plock!",
  text: "#{who} recommended a link to you! View it <https://www.theironyard.com|here!> ",
  icon_emoji: ":aardworlf:"
}
HTTParty.post "https://hooks.slack.com/services/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",
  body: {
    payload: data.to_json
  }
