class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.bigint :user_id, :null => false, :unique => true
      t.timestamps
    end
    add_column :likes, :post_id, :bigint
    add_foreign_key :likes, :posts
    add_index :likes, [:user_id, :post_id], unique: true
  end
end
