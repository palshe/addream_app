class UsersController < ApplicationController
  before_action :user_logged_in?, only: [:show]

  def show
    @user = current_user
  end

  protected
  def user_logged_in?
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end
end
