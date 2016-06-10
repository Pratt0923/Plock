class User < ActiveRecord::Base
  has_many :bookmarks
  has_many :recommendations, foreign_key: "recipient_id"
end
