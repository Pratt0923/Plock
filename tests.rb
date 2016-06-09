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
  #
  # def setup
  #   Plock.reset_database
  # end

  def make_existing_user
    User.create! id: 1, username: "fake", password: "password"
  end

  def make_bookmark
    Bookmark.create! user_id: 1, bookmark_url: "www.lsdfkjn.com", bookmark_name: "name", bookmark_description: "this is here"
  end

  def user_with_different_user_pass
    User.create! id: 2, username: "bad", password: "wrong"
  end


  focus
  def test_users_can_add_bookmarks

    make_existing_user
    3.times do
      make_bookmark
    end
    assert_equal 1, User.count
    assert_equal 3, Bookmark.count
  end

  # def test_users_cannot_add_bookmarks_without_being_logged_in
  #   assert_equal 0, User.count
  #   make_bookmark
  #   binding.pry
  #   assert_equal 0, Bookmark.count
  #   binding.pry
  # end



  def test_users_cannot_post_to_other_users_bookmarks
    user_with_different_user_pass
    3.times do
      make_existing_user.bookmarks.create!
    end
    assert_equal 0, user_with_different_user_pass.bookmarks.count
    # assert_equal 3,
    #need to make user and make another user. other user
    #needs to try and add something to usera's bookmarks and fail
  end
end
