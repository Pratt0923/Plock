class CreateRecommendation < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.string :recommend_to
      t.integer :bookmark_id
    end
  end
end
