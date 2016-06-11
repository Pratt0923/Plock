class Recommendation < ActiveRecord::Base

  validates_uniqueness_of :bookmark_id, scope: :user_id

  belongs_to :user
  belongs_to :recipient, class_name: "User"
  belongs_to :bookmark


end
