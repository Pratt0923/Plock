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

get "/users/my_bookmarks" do
  
end

post "/users/my_bookmarks" do


end
