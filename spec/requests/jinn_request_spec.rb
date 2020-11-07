require 'rails_helper'

RSpec.describe "Jinns", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/jinn"
      expect(response).to have_http_status(:success)
    end
  end
end
