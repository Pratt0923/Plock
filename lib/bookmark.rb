class Bookmark < ActiveRecord::Base
  validates_presence_of :bookmark_url, :bookmark_name, :bookmark_description

  belongs_to :user
  has_many :recommendations
def takes_in_user_name_and_gives_out_id

end
end
