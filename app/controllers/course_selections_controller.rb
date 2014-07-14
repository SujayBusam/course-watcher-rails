class CourseSelectionsController < ApplicationController
  before_action :correct_user, only: [:new]

  def new
    
  end

  def show
    @user = current_user
    @course = Course.find(params[:id])
    @course_selection = CourseSelection.find_by(user_id: @user.id, course_id: @course.id)
    @title = "#{@course.subject} #{@course.number}"
  end

  def create
    current_user.watch!(params[:course_subject], (params[:course_number]).to_i)
    redirect_to 'show'
  end

  def destroy
    
  end


  private

    # Before filters

    def correct_user
      @user = User.find(params[:user_id])
      unless current_user?(@user)
        flash[:warning] = "You're not allowed to view that page!"
        redirect_to root_url
      end
    end
end
