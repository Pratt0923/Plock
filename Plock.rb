require "pry"
require "sinatra/base"
require "sinatra/json"
require "./db/setup"
require "./lib/all"
require "rack/cors"
require "httparty"

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
    else
      # raise e
      puts e.message
    end
  end

  # before do
  #   require_authorization!
  # end
  #
  # def require_authorization!
  #   unless user
  #     status 401
  #     halt({ error: "You must log in" }.to_json)
  #   end
  # end
  #
  def user name, password
    User.find_by(username: name, password: password)
  end
  #----------------------------------------------------------------
  get "/my_bookmarks" do
    u = user params[:username], params[:password]
    if u && (u.bookmarks == [])
      status 400
      halt({error: "You have no bookmarks saved"}.to_json)
    elsif u
      status 200
      body json u.bookmarks
    else
      status 400
      halt({ error: "User not found" }.to_json)
    end
  end

  post "/my_bookmarks" do
    u = user params[:username], params[:password]
    u.bookmarks.create!(
    user_id: params[:user_id],
    bookmark_url: params[:bookmark_url],
    bookmark_name: params[:bookmark_name],
    bookmark_description: params[:bookmark_description]
    )
    json u.bookmarks
  end

  get "/recommendations" do
    u = user params[:username], params[:password]
    if u
      body json u.recommendations
    else
      status 400
      halt({ error: "User not found" }.to_json)
    end
  end

  post "/recommendations" do
    recommendation = params[:bookmark_id].to_i
    bookmark = Bookmark.find_by(id: recommendation)
    recipient = params[:recipient]

    r = User.find_by(username: recipient)
    u = user params[:username], params[:password]

    nr = Recommendation.create!(user_id: u.id, recipient_id: r.id, bookmark_id: bookmark.id)
    sender = u.username
    reciever = r.username

    data = {
      channel: "#plock_recommendations",
      username: "Plock!",
      text: "@#{sender} recommended a link to @#{reciever}! View it <#{bookmark.bookmark_url}|here!> ",
      icon_emoji: ":aardwolf:",
      link_names: 2
    }

    HTTParty.post "https://hooks.slack.com/services/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",
    body: {
      payload: data.to_json
    }
    binding.pry
    body json


  end

  get "/recommendations" do
    u = user params[:username], params[:password]
    if u
      status 200
      body json u.recommendations
    else
      status 400
    end
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
    binding.pry
    # end
  end
end

if $PROGRAM_NAME == __FILE__
  Plock.run!
end
