require 'rails_helper'
require './spec/support/devise'

RSpec.describe SavedBlogpostsController, type: :controller do
  let(:leo)                 { user(blogposts: 1, saved_blogposts: 1) }
  let(:leos_blogpost) {
    Blogpost.where(user_id: leo.id).order(:created_at).last
  }
  let(:leos_saved_blogpost) {
    SavedBlogpost.where(user_id: leo.id).order(:created_at).last
  }
  let(:raph)                { user(blogposts: 1) }
  let(:raphs_blogpost)      {
    Blogpost.where(user_id: raph.id).order(:created_at).last
  }
  let(:saved_blogpost_params) {
    {
      user_id:      leo.id,
      blogpost_id:  raphs_blogpost.id
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

    describe "POST #create" do
      it "doesn't create a saved blogpost" do
        leo
        expect {
          post :create, params: saved_blogpost_params
        }.not_to change { leo.reload.saved_blogposts.count }
      end

      it "redirects to the sign-in page" do
        post :create, params: saved_blogpost_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #destroy" do
      it "doesn't destroy Leo's saved blogpost" do
        expect {
          delete :destroy, params: { id: leos_saved_blogpost.id }
        }.not_to change { leo.reload.saved_blogposts.count }
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

    describe "POST #create" do
      it "creates a saved blogpost" do
        expect {
          post :create, params: saved_blogpost_params
        }.to change { leo.reload.saved_blogposts.count }.by(1)
      end

      it "redirects to the previous page" do
        leo
        post :create, params: saved_blogpost_params
        expect(response).to redirect_to(root_path)
      end
    end

    describe "DELETE #destroy" do
      it "destroys Leo's saved blogpost" do
        expect {
          delete :destroy, params: { id: leos_saved_blogpost.id }
        }.to change { leo.reload.saved_blogposts.count }.by(-1)
      end

      it "redirects to the saved blogpost index" do
        leos_saved_blogpost
        delete :destroy, params: { id: leos_saved_blogpost.id }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
