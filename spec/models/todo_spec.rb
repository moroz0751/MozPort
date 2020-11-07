require 'rails_helper'

RSpec.describe Todo, type: :model do
  let(:leo)           { user }
  let(:leos_todo)     {
    todo_params = {
      user_id: leo.id,
      task: "Write specs"
    }
    todo = leo.todos.build(todo_params)
    todo.save!
    todo
  }

  context "RelationsHelper concern" do
    describe "#created_by?" do
      it "matches the given creator" do
        expect(leos_todo.created_by?(leo)).to eq(true)
      end

      it "doesn't match the given creator" do
        raph = user
        expect(leos_todo.created_by?(raph)).to eq(false)
      end
    end
  end
end
