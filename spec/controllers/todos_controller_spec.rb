require 'rails_helper'
require './spec/support/devise'

RSpec.describe TodosController, type: :controller do
  let(:leo)         { user(todos: 1) }
  let(:leos_todo)   { Todo.where(user_id: leo.id).order(:created_at).last }
  let(:raph)        { user(todos: 1) }
  let(:raphs_todo)  { Todo.where(user_id: raph.id).order(:created_at).last }
  let(:todo_params) {
    {
      todo: {
        user_id:  leo.id,
        task:     "Write specs!"
      }
    }
  }

  before :each do
    request.env["HTTP_REFERER"] = root_path
  end

  context "while visiting anonymously," do
    describe "GET #index" do
      it "redirects to the sign-in page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #new" do
      it "redirects to the sign-in page" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do
      it "redirects to the sign-in page" do
        get :edit, params: { id: leos_todo.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do
      it "doesn't create a todo" do
        leo
        expect {
          post :create, params: todo_params
        }.not_to change { leo.reload.todos.count }
      end

      it "redirects to the sign-in page" do
        post :create, params: todo_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PATCH/PUT #update" do
      let!(:update_params) {
        {
          id: leos_todo.id,
          todo: {
            task:  "Give me all your money",
          }
        }
      }

      it "doesn't update the todo" do
        expect {
          patch :update, params: update_params
        }.not_to change {
          leo.reload.todos.order(:updated_at).last
        }
      end

      it "redirects to the previous page" do
        patch :update, params: update_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #destroy" do
      it "doesn't destroy the todo" do
        leo
        expect {
          delete :destroy, params: { id: leos_todo.id }
        }.not_to change { leo.reload.todos.count }
      end

      it "redirects to the sign-in page" do
        delete :destroy, params: { id: leos_todo.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "while signed-in as Leo," do
    before do
      sign_in leo
    end

    describe "GET #index" do
      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "GET #new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      describe "on Leo's todo" do
        it "renders the edit template" do
          get :edit, params: { id: leos_todo.id }
          expect(response).to render_template(:edit)
        end
      end

      describe "on Raph's todo" do
        it "doesn't find the todo" do
          expect{
            get :edit, params: { id: raphs_todo.id }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "POST #create" do
      it "creates a todo" do
        expect {
          post :create, params: todo_params
        }.to change { leo.reload.todos.count }.by(1)
      end
    end

    describe "PATCH/PUT #update" do
      let!(:update_params) {
        {
          id: leos_todo.id,
          todo: {
            task:  "Give me all your money"
          }
        }
      }

      describe "on Leo's todo" do
        it "updates the todo" do
          patch :update, params: update_params
          expect(
            leo.reload.todos.order(:updated_at).last.task
          ).to eq(update_params[:todo][:task])
        end
      end

      describe "on Raph's todo" do
        it "doesn't find the todo" do
          update_params[:id] = raphs_todo.id

          expect{
            patch :update, params: update_params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "DELETE #destroy" do
      describe "on Leo's todo" do
        it "deletes the todo" do
          expect {
            delete :destroy, params: { id: leos_todo.id }
          }.to change { leo.reload.todos.count }.by(-1)
        end

        it "redirects to the previous page" do
          delete :destroy, params: { id: leos_todo.id }
          expect(response).to redirect_to(root_path)
        end
      end

      describe "on Raph's todo" do
        it "doesn't find the todo" do
          expect{
            delete :destroy, params: { id: raphs_todo.id }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
