class JinnController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /jinn
  def index
  end

  # GET /jinn/predict
  def predict
    respond_to do |format|
      format.js { render partial: 'prophecy.js.erb' }
    end
  end
end
