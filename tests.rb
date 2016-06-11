require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'sinatra/base'
require 'minitest/reporters'
require "./db/setup"
require "./lib/all"
require "./Plock"
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


  # def setup
  #   Bookmark.delete_all
  #   Recommendation.delete_all
  # end

  def test_users_can_see_bookmarks

    r = get "/my_bookmarks", params = {"username": "fake", "password": "password"}
    assert_equal 200, r.status
  end

focus
  def test_users_can_add_bookmarks
    p = post "/my_bookmarks", params = {
      "username": "fake",
      "password": "password",
      "bookmark_url": "http://google.com",
      "bookmark_name": "Some cool article",
      "bookmark_description": "You should revisit this"
    }
    assert_equal 1, User.count
    assert_equal 1, Bookmark.count
  end

  def test_users_cannot_post_to_other_users_bookmarks
    User.create! username: "pass"
    User.create! username: "tests"
    rightuser = User.where(username: "pass")
    wronguser = User.where(username: "tests")
    wronguser.first.bookmarks.create!
    assert_equal 0, rightuser.first.bookmarks.count
    assert_equal 1, wronguser.first.bookmarks.count
  end
focus
  def test_users_can_post_recommendations
    r = post "/recommendations", params = {
      "username": "vegajdr",
      "password": "password",
      "bookmark_id": 155,
      "recipient": "erikpetersen",
    }
    binding.pry
    assert_equal 200, r.status
  end

  def users_can_post_recommendations
    make_existing_user
    user = User.find_by(username: "fake", password: "password")
    assert_equal 0, user.recommendations.count
    user.recommendations.create!
    assert_equal 1, user.recommendations.count
  end

  def user_can_see_own_recommendations
    make_existing_user
    user = User.find_by(username: "fake", password: "password")
    user.recommendations.create!
    assert_equal 1, Recommendations.where(user_id: user.id)
  end

  def test_user_can_delete_bookmarks
    make_existing_user
    user = User.find_by(username: "fake", password: "password")
    binding.pry
    user.bookmarks.create!(user_id: user.id, bookmark_url: "www.com", bookmark_name: "name", bookmark_description: "desc")
    user.bookmarks.create!(user_id: user.id, bookmark_url: "www.com", bookmark_name: "name", bookmark_description: "desc")
    bookid = user.bookmarks.last.id
    r = post "/#{bookid}/my_bookmarks"
    binding.pry
    assert_equal 1, user.bookmarks.count
  end
end
