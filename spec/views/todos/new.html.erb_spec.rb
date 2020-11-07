require 'rails_helper'

RSpec.describe "todos/new", type: :view do
  before(:each) do
    leo = user
    assign(:todo, Todo.new(
      user_id: leo.id,
      task: "My Task"
    ))
  end

  it "renders new todo form" do
    render

    assert_select "form[action=?][method=?]", todos_path, "post" do
      assert_select "input[name=?]", "todo[task]"
      assert_select "input[name=?]", "commit"
      assert_select "a[href=?]", root_path
    end
  end
end
