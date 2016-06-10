class User < ActiveRecord::Base
  has_many :bookmarks
  has_many :recommendations
end
