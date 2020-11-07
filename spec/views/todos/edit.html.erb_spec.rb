require 'rails_helper'

RSpec.describe "todos/edit", type: :view do
  before(:each) do
    leo = user(todos: 1)
    @todo = assign(:todo, Todo.create!(
      user_id: leo.id,
      task: "My Task"
    ))
  end

  it "renders the edit todo form" do
    render

    assert_select "form[action=?][method=?]", todo_path(@todo), "post" do
      assert_select "input[name=?]", "todo[task]"
      assert_select "input[name=?]", "commit"
      assert_select "a[href=?]", root_path
    end
  end
end
