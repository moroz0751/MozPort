class TodosController < ApplicationController
  # GET /todos
  # GET /todos.json
  def index
    @todos = current_user.todos
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/check
  def check_off
    todo = get_todo(user: current_user)
    todo.status =
        todo.status == "not_completed" ? "completed" : "not_completed"
    todo.save!

    redirect_back fallback_location: root_path
  end

  # GET /todos/1/edit
  def edit
    @todo = get_todo(user: current_user)
  end

  # POST /todos
  # POST /todos.json
  def create
    todo = current_user.todos.build(todo_params)

    respond_to do |format|
      if todo.save
        format.html { redirect_to todos_path }
        format.json { render :show, status: :created, location: todo }
      else
        format.html { render :new }
        format.json { render json: todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1
  # PATCH/PUT /todos/1.json
  def update
    todo = get_todo(user: current_user)

    respond_to do |format|
      if todo.update(todo_params)
        format.html { redirect_back fallback_location: root_path }
        format.json { render :show, status: :ok, location: todo }
      else
        format.html { render :edit }
        format.json { render json: todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    todo = get_todo(user: current_user)

    todo.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.json { head :no_content }
    end
  end

  private

    def get_todo(user: current_user)
      user.todos.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:task, :status)
    end
end
