require 'rails_helper'
require './spec/support/devise'

RSpec.describe BlogpostsController, type: :controller do
  let(:leo)                 { user(blogposts: 1) }
  let(:leos_blogpost)       {
    Blogpost.where(user_id: leo.id).order(:created_at).last
  }
  let(:raph)                { user(blogposts: 1) }
  let(:raphs_blogpost)      {
    Blogpost.where(user_id: raph.id).order(:created_at).last
  }
  let(:blogpost_params) {
    {
      blogpost: {
        title: "Cheese is evil",
        body: "It kills 260 people per year."
      }
    }
  }

  before :each do
    request.env["HTTP_REFERER"] = root_path
  end

  context "while visiting anonymously," do
    describe "GET #index" do
      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe "GET #show" do
      it "renders the show template" do
        get :show, params: { id: leos_blogpost.id }
        expect(response).to render_template(:show)
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
        get :edit, params: { id: leos_blogpost.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do
      it "doesn't create a blogpost" do
        expect {
          post :create, params: blogpost_params
        }.not_to change { Blogpost.count }
      end

      it "redirects to the sign-in page" do
        post :create, params: blogpost_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PATCH/PUT #update" do
      let!(:update_params) {
        {
          id: leos_blogpost.id, # id of the blogpost being updated (unchanged)
          blogpost: {
            title:  blogpost_params[:blogpost][:title],
            body:   blogpost_params[:blogpost][:body]
          }
        }
      }

      it "doesn't update Leo's blogpost" do
        expect {
          patch :update, params: update_params
        }.not_to change {
          leo.reload.blogposts.order(:updated_at).last
        }
      end

      it "redirects to the sign-in page" do
        patch :update, params: update_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #destroy" do
      it "doesn't destroy Leo's blogpost" do
        leos_blogpost
        expect {
          delete :destroy, params: { id: leos_blogpost.id }
        }.not_to change { leo.reload.blogposts.count }
      end

      it "redirects to the sign-in page" do
        delete :destroy, params: { id: leos_blogpost.id }
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

    describe "GET #show" do
      it "renders the show template" do
        get :show, params: { id: leos_blogpost.id }
        expect(response).to render_template(:show)
      end
    end

    describe "GET #new" do
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    describe "GET #edit" do
      describe "on Leo's blogpost" do
        it "renders the edit template" do
          get :edit, params: { id: leos_blogpost.id }
          expect(response).to render_template(:edit)
        end
      end

      describe "on Raph's blogpost" do
        it "doesn't find the blogpost" do
          expect{
            get :edit, params: { id: raphs_blogpost.id }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "POST #create" do
      it "creates a new blogpost" do
        expect {
          post :create, params: blogpost_params
        }.to change { leo.reload.blogposts.count }.by(1)
      end

      it "redirects to the show template" do
        post :create, params: blogpost_params
        expect(response).to redirect_to(leos_blogpost.reload)
      end
    end

    describe "PATCH/PUT #update" do
      describe "on Leo's blogpost" do
        let!(:update_params) {
          {
            id: leos_blogpost.id,
            blogpost: {
              title:  blogpost_params[:blogpost][:title],
              body:   blogpost_params[:blogpost][:body]
            }
          }
        }

        it "updates the blogpost" do
          patch :update, params: update_params
          expect(
            leo.reload.blogposts.order(:updated_at).last.title
          ).to eq(update_params[:blogpost][:title])
          expect(
            leo.reload.blogposts.order(:updated_at).last.body
          ).to eq(update_params[:blogpost][:body])
        end

        it "redirects to the show view of the newly-created blogpost" do
          patch :update, params: update_params
          expect(response).to redirect_to(leos_blogpost)
        end
      end

      describe "on Raph's blogpost" do
        let!(:update_params) {
          {
            id: raphs_blogpost.id,
            blogpost: {
              title:  blogpost_params[:blogpost][:title],
              body:   blogpost_params[:blogpost][:body]
            }
          }
        }

        it "doesn't find the blogpost" do
          expect {
            patch :update, params: update_params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe "DELETE destroy" do
      describe "on Leo's blogpost" do
        it "deletes the blogpost" do
          expect {
            delete :destroy, params: { id: leos_blogpost.id }
          }.to change { leo.reload.blogposts.count }.by(-1)
        end

        it "redirects to the previous page" do
          delete :destroy, params: { id: leos_blogpost.id }
          expect(response).to redirect_to(root_path)
        end
      end

      describe "on Raph's blogpost" do
        it "doesn't find the blogpost" do
          expect {
            delete :destroy, params: { id: raphs_blogpost.id }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
