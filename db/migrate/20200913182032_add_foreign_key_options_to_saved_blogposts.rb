class AddForeignKeyOptionsToSavedBlogposts < ActiveRecord::Migration[6.0]
  def up
    change_table :saved_blogposts do |t|
      # 1. Add temporary columns
      t.integer :user_id_tmp
      t.integer :blogpost_id_tmp

      # 2. Fill in from foreign keys
      SavedBlogpost.update_all('user_id_tmp = user_id')
      SavedBlogpost.update_all('blogpost_id_tmp = blogpost_id')

      # 3. Remove old columns
      t.remove :user_id
      t.remove :blogpost_id

      # 4. Add new references
      t.references :user, null: true, foreign_key: true
      t.references :blogpost, null: true, foreign_key: true

      # 5. Fill in from temporary columns
      SavedBlogpost.update_all('user_id = user_id_tmp')
      SavedBlogpost.update_all('blogpost_id = blogpost_id_tmp')

      # 6. Remove temporary columns
      t.remove :user_id_tmp
      t.remove :blogpost_id_tmp 
    end

    # 7. Set null to false
    change_column_null :saved_blogposts, :user_id, false
    change_column_null :saved_blogposts, :blogpost_id, false
  end

  def down 
    change_table :saved_blogposts do |t|
      # 1. Add temporary columns
      t.integer :user_id_tmp
      t.integer :blogpost_id_tmp

      # 2. Fill in from foreign keys
      SavedBlogpost.update_all('user_id_tmp = user_id')
      SavedBlogpost.update_all('blogpost_id_tmp = blogpost_id')

      # 3. Remove old columns
      t.remove :user_id
      t.remove :blogpost_id

      # 4. Add new columns
      t.integer :user_id, null: true
      t.integer :saved_blogposts, null: true

      # 5. Fill in from temporary columns
      SavedBlogpost.update_all('user_id = user_id_tmp')
      SavedBlogpost.update_all('blogpost_id = blogpost_id_tmp')

      # 6. Remove temporary columns
      t.remove :user_id_tmp
      t.remove :blogpost_id_tmp
    end

    # 7. Set null to false
    change_column_null :saved_blogposts, :user_id, false
    change_column_null :saved_blogposts, :blogpost_id, false
  end
end
