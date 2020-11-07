require 'rails_helper'

RSpec.describe "todos/index", type: :view do
  before(:each) do
    leo = user(todos: 2)
    @todos = leo.todos.all
  end

  it "renders a list of todos" do
    render
    assert_select "tr>td", text: "Conquer the world".to_s, count: 2
  end
end
