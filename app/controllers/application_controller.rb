class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  BLOGPOSTS_PER_REQUEST = 5

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(
        :sign_up,
        keys: [:first_name, :last_name, :avatar]
      )

      devise_parameter_sanitizer.permit(
        :account_update,
        keys: [:first_name, :last_name, :avatar]
      )
    end

    # Find the user object
    def find_user
      User.find(params[:user_id])
    end
end
