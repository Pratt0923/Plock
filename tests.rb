require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'sinatra/base'
require 'minitest/reporters'
require "./db/setup"
require "./lib/all"
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
# require './app'
class PlockTests < Minitest::Test
  include Rack::Test::Methods

  def app
    Plock
  end

  def setup
    Plock.reset_database
  end

  def make_existing_user
    User.create! username: "Existing", password: "User"
  end

  def make_bookmark
    Bookmark.create! user_id: user.id, bookmark_url: "www.lsdfkjn.com", bookmark_name: "name", bookmark_description: "this is here"
  end

  def make_item
    Bookmark.create!(
    user_id: 1,
    bookmark_url: "www.eslfkjhzsf.com",
    bookmark_name: "name",
    bookmark_description: "desc"
    )
  end

  def users_can_add_bookmarks
    User.make_existing_user
    3.times do
      make_bookmark
    end
    assert_equal 1, User.count
    assert_equal 3, Bookmark.count
  end
end
