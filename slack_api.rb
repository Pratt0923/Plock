require "httparty"
require "./token.rb"
# link = "https://slack.com/api/"


def get_slack
  HTTParty.get(
    "https://slack.com/api",
      headers: {
        "Authorization" => "token #{Token}"
      }
    )
end

get_slack
