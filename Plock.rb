require "pry"
require "sinatra/base"
require "sinatra/json"

require "./db/setup"
require "./lib/all"

class PlockApp < ActiveRecord::Base
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

  def user
    user = User.find_by(password: env["HTTP_AUTHORIZATION"])
  end
  #
  # before do
  #   if user
  #   else
  #     halt 403
  #   end
  # end

# get "/users/my_bookmarks" do
#   bookmarks = Bookmark.where(user_id: user.id)
#   bookmarks.all.to_json
# end
#
# post "/users/my_bookmarks" do
#   Bookmark.create!(
#   user_id: params[:user_id],
#   bookmark_url: params[:bookmark_url],
#   bookmark_name: params[:bookmark_name],
#   bookmark_description: params[:bookmark_description]
#   )
# end

get "/users/dummy" do
  user = {
    "1" => {"bookmark_name" => "Article", "bookmark_description" => "Great Read!", "bookmark_url" => "https://www.notawebsite.com/article"},
    "2" => {"bookmark_name" => "Video", "bookmark_description" => "Cool cat video", "bookmark_url" => "https://www.notawebsite.com/catvideo"}
  }
  body user.to_json
end
end
