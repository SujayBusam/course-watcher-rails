class StaticPagesController < ApplicationController

  def home
    @current_page = 'home'
  end

  def about
    @current_page = 'about'
  end

  def help
    @current_page = 'help'
  end

  def faq
    @current_page = 'faq'
  end
end
