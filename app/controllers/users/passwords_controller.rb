# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  #skip_before_filter :require_no_authentication, only: [:new]
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

   protected

   #def after_resetting_password_path_for(resource)
    # users_passwordreset_path
   #end

  # The path used after sending reset password instructions
   def after_sending_reset_password_instructions_path_for(resource_name)
     users_passwordreset_path
   end
end
