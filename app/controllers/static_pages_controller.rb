class StaticPagesController < ApplicationController

  def home
    @user = User.new
    @current_page = 'home'
  end

  def about
    @current_page = 'about'
  end

  def contact
    @current_page = 'contact'
  end

end
