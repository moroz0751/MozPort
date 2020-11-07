class SavedBlogpostsController < ApplicationController
  skip_before_action :authenticate_user!, except: [:index, :create, :destroy]

  # GET /saved_blogposts
  # GET /saved_blogposts.json
  def index
    # Limiting content
    limit = Blogpost.limit_blogposts(BLOGPOSTS_PER_REQUEST)

    @saved_blogposts, @has_more =
      SavedBlogpost.get_saved_blogposts(limit, user: current_user)
  end

  # GET /saved_blogposts/more
  # Renders additional blogposts if user requests more content
  def more
    limit = Blogpost.limit_blogposts(BLOGPOSTS_PER_REQUEST, more_counter: params[:more])

    saved_blogposts, @has_more =
      SavedBlogpost.get_saved_blogposts(limit, user: current_user)
    blogposts_displayed =
      Blogpost.max_blogposts_displayed(BLOGPOSTS_PER_REQUEST, more_counter: params[:more])
    @saved_blogposts_to_render = saved_blogposts[blogposts_displayed..-1]

    respond_to do |format|
      format.js  { render partial: 'shared/blogposts/more_blogposts.js.erb' }
    end
  end

  # POST /saved_blogposts
  # POST /saved_blogposts.json
  def create
    blogpost = Blogpost.find(params[:blogpost_id])
    saved_blogpost = current_user.build_saved_blogpost(blogpost)

    respond_to do |format|
      if !saved_blogpost
        format.html do
          redirect_back(
            fallback_location: root_path,
            notice: 'Blogpost already in your Saved Posts.'
          )
        end
        format.json do
          render :show,
          status: :created,
          location: saved_blogpost
        end
      elsif saved_blogpost.save
        format.html { redirect_back fallback_location: root_path }
        format.json do
          render :show,
          status: :created,
          location: saved_blogpost
        end
      else
        format.html { render :new }
        format.json do
          render json: saved_blogpost.errors,
          status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /saved_blogposts/1
  # DELETE /saved_blogposts/1.json
  def destroy
    saved_blogpost = get_saved_blogpost(user: current_user)

    respond_to do |format|
      if saved_blogpost.destroy
        format.html { redirect_back fallback_location: root_path }
        format.json { head :no_content }
      else
        redirect_back(
          fallback_location: root_path,
          alert: "An error has occurred."
        )
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def get_saved_blogpost(user: current_user)
      if current_user.is_master_admin?
        SavedBlogpost.find(params[:id])
      else user
        user.saved_blogposts.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def saved_blogpost_params
      params.require(:saved_blogpost).permit(:user_id, :blogpost_id)
    end
end
