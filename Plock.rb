require "pry"
require "sinatra/base"
require "sinatra/json"
require "./db/setup"
require "./lib/all"
require "rack/cors"
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
    url = params[:bookmark_url]
    recipient = params[:recipient]
    u = user params[:username], params[:password]
    r = Recommendation.new(user_id: u.id, recipient_id: recipient.username, bookmark_id: url)
  end

  # get "/recommendations" do
  #   u = user params[:username], params[:password]
  #   if u
  #     status 200
  #     body json u.recommendations
  #   else
  #     status 400
  #   end
  # end
end

if $PROGRAM_NAME == __FILE__
  Plock.run!
end
