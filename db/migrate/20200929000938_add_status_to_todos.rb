class AddStatusToTodos < ActiveRecord::Migration[6.0]
  def change
    add_column :todos, :status, :integer, null: false, default: 0
  end
end
