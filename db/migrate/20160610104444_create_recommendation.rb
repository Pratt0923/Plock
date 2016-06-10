class CreateRecommendation < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.integer :recipient_id
      t.integer :bookmark_id
    end
  end
end
