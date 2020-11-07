class CreateSavedBlogposts < ActiveRecord::Migration[6.0]
  def change
    create_table :saved_blogposts do |t|
      t.integer :user_id, null: false
      t.integer :blogpost_id, null: false

      t.timestamps
    end
  end
end
