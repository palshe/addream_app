class ApplicationController < ActionController::Base
  include Devise::Controllers::Helpers
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resourse)
    root_path
  end

  def after_sending_reset_password_instructions_path_for(resource_name)
    users_passwordreset_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
