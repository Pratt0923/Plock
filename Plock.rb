require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"

class Plock < ActiveRecord::Base
  set :logging, true
  set :show_exceptions, false

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

  before do
    require_authorization!
  end

  def require_authorization!
    unless user
      status 401
      halt({ error: "You must log in" }.to_json)
    end
  end

  def user
    user = User.find_by(username: "username", password: "password")
  end
#----------------------------------------------------------------
  get "/users/my_bookmarks" do
  end

  post "/users/my_bookmarks" do
    Bookmark.create!(
    user_id: params[:user_id],
    bookmark_url: params[:bookmark_url],
    bookmark_name: params[:bookmark_name],
    bookmark_description: params[:bookmark_description]
    )
  end
end
