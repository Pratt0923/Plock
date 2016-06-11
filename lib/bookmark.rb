class Bookmark < ActiveRecord::Base
  validates_presence_of :bookmark_url, :bookmark_name, :bookmark_description
  validates_uniqueness_of :bookmark_url, scope: :user_id

  belongs_to :user
  has_many :recommendations

end
