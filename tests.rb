require 'pry'
require 'minitest/autorun'
require 'minitest/focus'
require 'sinatra/base'
require 'minitest/reporters'
require "./db/setup"
require "./lib/all"
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'
require './plock'
class AppTests < Minitest::Test
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

  def make_item
    Bookmark.create!(
    user_id: 1,
    bookmark_url: "www.eslfkjhzsf.com",
    bookmark_name: "name",
    bookmark_description: "desc"
    )
  end

  def test_can_add_users
    assert_equal 0, User.count

    r = post "/users", username: "New", password: "User"
    assert_equal 200, r.status
    assert_equal 1, User.count
    assert_equal "New", User.first.username
  end

  def test_users_can_add_items

    user = make_existing_user
    header "Authorization", user.password
    assert_equal 0, Item.count

    r = post "/items", description: "New Hotness", price: 100.00

    assert_equal 200, r.status
    assert_equal 1, Item.count
    assert_equal "New Hotness", Item.first.description
  end

  def test_users_can_buy_items
    user = make_existing_user
    item = make_item
    header "Authorization", user.password

    r = post "/items/#{item.id}/buy", quantity: 5
    assert_equal 200, r.status
    assert_equal 1, Purchase.count
    assert_equal 5, Purchase.first.quantity

    assert_equal Purchase.first, user.purchases.first
  end

  def test_users_cant_buy_non_items
    user = make_existing_user

    header "Authorization", user.password
    assert_raises ActiveRecord::RecordNotFound do
      post "/items/99999/buy", quantity: 5
    end

    assert_equal 0, Purchase.count
  end

  def test_users_cant_delete_arbitrary_items
    item = make_item
    user = make_existing_user
    header "Authorization", user.password
    r = delete "/items/#{item.id}"
    assert_equal 403, r.status
    assert_equal 1, Item.count
  end

  def test_users_can_delete_their_items
    user = make_existing_user
    item = make_item
    header "Authorization", user.password
    item.listed_by = user
    item.save!
    r = delete "/items/#{item.id}"
    assert_equal 200, r.status
    assert_equal 0, Item.count
  end

  def test_users_can_see_who_has_ordered_an_item
    item = make_item
    3.times do |i|
      u = User.create! username: i, password: i
      u.purchases.create! item: item, quantity: 4
    end
    r = get "/items/#{item.id}/purchases"
    assert_equal 200, r.status
    body = JSON.parse r.body
    assert_equal 3, body.count
  end
end
