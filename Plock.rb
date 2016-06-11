require "pry"
require "sinatra/base"
require "sinatra/json"
require "./db/setup"
require "./lib/all"
require "rack/cors"
require "httparty"
require "uri"

class Plock < Sinatra::Base
  set :logging, true
  set :show_exceptions, false

  use Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: :any
    end
  end
  #
  error do |e|
    if e.is_a? ActiveRecord::RecordNotFound
      halt 404
    elsif e.is_a? ActiveRecord::RecordInvalid
      json error: e.message
    elsif e.is_a? ActiveRecord::RecordNotUnique
      status 400
      json error: e.message
    else
      # raise e
      puts e.message
    end
  end

  def user name, password
    User.find_by(username: name, password: password)
  end
  #----------------------------------------------------------------
  get "/my_bookmarks" do
    u = user params[:username], params[:password]
    if u
      status 200
      body json u.bookmarks
    else
      status 400
      halt({ error: "User not found" }.to_json)
    end
  end

  post "/my_bookmarks" do
    u = user params[:username], params[:password]
    if params[:bookmark_url] =~ /\A#{URI::regexp(['http', 'https'])}\z/
      u.bookmarks.create!(
      user_id: params[:user_id],
      bookmark_url: params[:bookmark_url],
      bookmark_name: params[:bookmark_name],
      bookmark_description: params[:bookmark_description]
      )
      status 200
      json u.bookmarks
    else
      status 422

      halt({error: "That is not a valid URL (Please include the 'http' section)"}.to_json)
    end
  end

  get "/recommendations" do
    u = user params[:username], params[:password]
    if u
      status 200
      body json u.recommendations
    else
      status 400
      halt({ error: "User not found" }.to_json)
    end
  end

  post "/recommendations" do
    u = user params[:username], params[:password]
    if u
      recommendation = params[:bookmark_id].to_i
      bookmark = Bookmark.find_by(id: recommendation)
      recipient = params[:recipient]
      r = User.find_by(username: recipient)
      u = user params[:username], params[:password]
      nr = Recommendation.create!(user_id: u.id, recipient_id: r.id, bookmark_id: bookmark.id)
      sender = u.username
      data = {
        channel: "#plock_recommendations",
        username: "Plock!",
        text: "@#{sender} recommended a link to @#{r.username}! View it <#{bookmark.bookmark_url}|here!> ",
        icon_emoji: ":aardwolf2:",
        link_names: 2
      }
      HTTParty.post "https://hooks.slack.com/services/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",
      body: {
        payload: data.to_json
      }

      status 200
      body json r.recommendations
    else
      status 400
      halt({error: "User not found"}.to_json)
  end

  post "/:id/my_bookmarks" do
    u = user params[:username], params[:password]
    # if u
    deleting_item = u.bookmarks.find_by(:id)
    binding.pry
    deleting_item.delete
    status 200
    binding.pry
    # else
    status 404
    halt({ error: "Can not delete bookmark" }.to_json)
    # end
  end
end


if $PROGRAM_NAME == __FILE__
  Plock.run!
end
