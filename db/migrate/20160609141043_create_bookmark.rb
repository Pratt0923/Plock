class CreateBookmark < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.string :bookmark_url
      t.string :bookmark_name
      t.string :bookmark_description
    end
  end
end
