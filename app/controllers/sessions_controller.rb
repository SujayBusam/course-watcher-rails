class SessionsController < ApplicationController

  def new

  end

  def create
    user_email = params[:session][:email]
    user_password = params[:session][:password]
    user = User.find_by(email: user_email.downcase)

    if user && user.authenticate(user_password) 
      sign_in user
      flash[:success] = "Welcome to CourseWatch!"
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'Invalid email / password combo.'
      render 'new'
    end
  end

  def destroy
  end
end
