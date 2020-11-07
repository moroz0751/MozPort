class AddUserIdToBlogposts < ActiveRecord::Migration[6.0]
  def up
    # Allow null values temporarily to fill in data
    add_reference :blogposts, :user, null: true, foreign_key: true

    # Assume every previous post was created by master admin
    Blogpost.all.each do |post|
      post.user_id = 1
      post.save!
    end

    # Disable null values for user references
    change_column :blogposts, :user_id, :integer, null: false
  end

  def down
    remove_column :blogposts, :user_id
  end
end
