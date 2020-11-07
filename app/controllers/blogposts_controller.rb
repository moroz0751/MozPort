class BlogpostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :more, :show]

  # GET /blogposts
  # GET /blogposts.json
  def index
    # Limiting content
    limit = Blogpost.limit_blogposts(BLOGPOSTS_PER_REQUEST)

    # Requesting user-specific posts
    if params[:user_id]
      @user = User.find(params[:user_id])
      @blogposts, @has_more = Blogpost.get_blogposts(limit, user: @user)
    # Requesting 'My posts' is marked with :not_authenticated
    # when the user is not signed in
    elsif params[:must_authenticate]
      authenticate_user!
      redirect_to blogposts_path(user: current_user) and return
    # Requesting unfiltered posts
    else
      @blogposts, @has_more = Blogpost.get_blogposts(limit, user: nil)
    end
  end

  # GET /blogposts/more
  # Renders additional blogposts if user requests more content
  def more
    limit = Blogpost.limit_blogposts(BLOGPOSTS_PER_REQUEST, more_counter: params[:more])

    # Requesting more user-specific posts
    if params[:user_id]
      @user = User.find(params[:user_id])
      blogposts, @has_more = Blogpost.get_blogposts(limit, user: @user)
    # Requesting more unfiltered posts
    else
      blogposts, @has_more = Blogpost.get_blogposts(limit, user: nil)
    end

    blogposts_displayed =
      Blogpost.blogposts_displayed(BLOGPOSTS_PER_REQUEST, more_counter: params[:more])
    @blogposts_to_render = blogposts[blogposts_displayed..-1]

    respond_to do |format|
      format.js { render partial: 'shared/blogposts/more_blogposts.js.erb' }
    end
  end

  # GET /blogposts/1
  # GET /blogposts/1.json
  def show
    @blogpost = get_blogpost
    @full_length = true
  end

  # GET /blogposts/new
  def new
    @blogpost = Blogpost.new
  end

  # GET /blogposts/1/edit
  def edit
    @blogpost = get_blogpost(user: current_user)
  end

  # POST /blogposts
  # POST /blogposts.json
  def create
    @blogpost = current_user.blogposts.build(blogpost_params)

    respond_to do |format|
      if @blogpost.save
        format.html do
          redirect_to @blogpost, notice: 'Blogpost was successfully created.'
        end
        format.json { render :show, status: :created, location: @blogpost }
      else
        format.html { render :new }
        format.json do
          render json: @blogpost.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /blogposts/1
  # PATCH/PUT /blogposts/1.json
  def update
    @blogpost = get_blogpost(user: current_user)

    respond_to do |format|
      if @blogpost.update(blogpost_params)
        format.html do
          redirect_to @blogpost, notice: 'Blogpost was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @blogpost }

        @updated_blogpost = @blogpost
        ActionCable.server.broadcast(
          'blogposts',
          blogpost: @blogpost,
          html: render_to_string(
            partial: 'shared/blogposts/blogpost',
            object: @blogpost,
            layout: false
          )
        )
      else
        format.html { render :edit }
        format.json do
          render json: @blogpost.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /blogposts/1
  # DELETE /blogposts/1.json
  def destroy
    blogpost = get_blogpost(user: current_user)
    blogpost.destroy!

    respond_to do |format|
      format.html do
        redirect_back(
          fallback_location: root_path,
          notice: 'Blogpost was successfully deleted.'
        )
      end
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def get_blogpost(user: nil)
      if user && current_user.is_master_admin?
        Blogpost.find(params[:id])
      elsif user
        user.blogposts.find(params[:id])
      else
        Blogpost.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def blogpost_params
      params.require(:blogpost).permit(:title, :body)
    end
end
