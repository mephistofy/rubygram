class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :comment, :null => false, :limit => 200 #By default SQL String limit 255 character 
      #Ex:- :limit => 40
      #Ex:- :null => false
      t.timestamps
    end
    add_column :comments, :post_id, :bigint
    add_foreign_key :comments, :posts
    add_column :comments, :author_id, :bigint, :null => false
  end
end
