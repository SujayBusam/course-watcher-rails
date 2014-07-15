class CourseSelectionsController < ApplicationController
  include CourseSelectionsHelper

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
    input_subject = params[:course_subject].strip.upcase
    input_number = params[:course_number].to_i

    # If user is already watching course, show alert. Otherwise, make the user
    # watch the course
    if current_user.watching_course?(input_subject, input_number)
      flash[:danger] = "You're already watching #{input_subject} #{input_number}."
      redirect_to new_course_selection_path

    else
      @course_selection_or_course = current_user.watch(input_subject, input_number)
      if @course_selection_or_course.errors.empty?
        if @course_selection_or_course.class == CourseSelection
          subject = @course_selection_or_course.course.subject
          number = @course_selection_or_course.course.number
        else
          subject = @course_selection_or_course.subject
          number = @course_selection_or_course.number
        end
        
        # Potential Ajax implementation here!
        flash[:success] = "Course: #{subject} #{number} added."
        redirect_to user_path(current_user)
      else
        render 'new'
      end
    end
  end

  def destroy
    
  end
end
