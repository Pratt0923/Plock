require "httparty"
# link = "https://slack.com/api/"


def get_slack
  HTTParty.get(
    "https://slack.com/api",
      headers: {
        "Authorization" => "token #{xoxp-9851937330-43034174288-49696337858-7f5ffceef9}"
      }
    )
end

get_slack
