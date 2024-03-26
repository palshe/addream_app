class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:activation]
  def home
  end

  def about
  end

  def help
  end

  def rules
  end

  def privacypolicy
  end
end
