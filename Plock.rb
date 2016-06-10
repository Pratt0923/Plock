require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"


class Plock < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
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
  def user
    user = User.find_by(username: "fake", password: "password")
  end
#----------------------------------------------------------------
  get "/my_bookmarks" do
    username = params[:username]
    password = params[:password]
    user = User.find_by(username: username, password: password)
    json user.bookmarks
  end

  post "/my_bookmarks" do
    user.bookmarks.create!(
    user_id: user.id,
    bookmark_url: params[:bookmark_url],
    bookmark_name: params[:bookmark_name],
    bookmark_description: params[:bookmark_description]
    )
  end

  post "/recommendations" do
    bookmark = user.bookmarks.find_by(bookmark_name: "name")
    user.recommendations.create!(
    user_id: user.id,
    recommend_to: params[:recommend_to],
    bookmark_id: bookmark.id
    )
  end

  get "/recommendations" do
    user = User.find_by(username: username, password: password)
    json Recommendations.where(user_id: user.id)
  end
end
