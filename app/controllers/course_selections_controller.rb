class CourseSelectionsController < ApplicationController

  def new
    @course_selection_or_course = CourseSelection.new
  end

  def show
    @user = current_user
    @course = Course.find(params[:id])
    @course_selection = CourseSelection.find_by(user_id: @user.id, course_id: @course.id)
    @title = "#{@course.subject} #{@course.number}"
  end

  def create
    # If user is already watching course, show alert. Otherwise, make the user
    # watch the course
    if current_user.watching_course?(params[:course_subject], 
                                    (params[:course_number]).to_i)
      flash[:danger] = "You're already watching that course."
      redirect_to new_course_selection_path
    else
      @course_selection_or_course = current_user.watch(params[:course_subject], 
                                                      (params[:course_number]).to_i)
      if @course_selection_or_course.errors.count > 0
        render 'new'
      else
        flash[:success] = "Course: #{@course_selection_or_course.subject} 
        #{@course_selection_or_course.number} added."
        redirect_to user_path(current_user)
      end
    end
  end

  def destroy
    
  end
end
