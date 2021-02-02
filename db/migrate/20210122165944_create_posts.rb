class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :avatar
    create_table :posts do |t|
      t.timestamps
    end
    add_column :posts, :image_data, :text
    add_column :posts, :user_id, :bigint
    add_foreign_key :posts, :users
  end
end
