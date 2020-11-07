class CreateBlogposts < ActiveRecord::Migration[6.0]
  def change
    create_table :blogposts do |t|
      t.string :title, null: false, foreign_key: true
      t.text :body, null: false, foreign_key: true

      t.timestamps
    end
  end
end
