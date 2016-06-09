require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'sinatra/base'
require 'minitest/reporters'
require "./db/setup"
require "./lib/all"
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './app'
class AppTests < Minitest::Test
  include Rack::Test::Methods

  def app
    Plock
  end

  def setup
    Plock.reset_database
  end

  def make_existing_user
    User.create! first_name: "Existing", last_name: "User", password: "hunter2"
  end

  def make_item
    Item.create! description: "Old Busted", price: 3.50
  end
