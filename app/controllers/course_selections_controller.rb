class CourseSelectionsController < ApplicationController
  before_action :signed_in_user
  # TODO correct user check for showing and deleting course selections

  def new
    @course = Course.new
  end

  def show
    @user = current_user
    @course = Course.find(params[:id])
    @course_selection = CourseSelection.find_by(user_id: @user.id, 
                                                course_id: @course.id)
    @title = "#{@course.subject} #{@course.number}"
  end

  def create
    @input_subject = params[:course_subject].strip.upcase
    @input_number = params[:course_number].to_i
    @input_section = params[:course_section]

    # Make the user watch the course if not already watching it
    if current_user.watching_course?(@input_subject, @input_number, 
                                     @input_section)
      flash[:danger] = "You're already watching #{@input_subject} #{@input_number}."
      redirect_to new_course_selection_path
    else
      @course_set = current_user.watch(@input_subject, @input_number, 
                                       @input_section)
      @course = @course_set.first

      # The course has several sections and/or labs. User needs to specify 
      # which one to watch
      if @course_set.count > 1
        render 'new'

      # One course section. Course selection has been made or course wasn't valid
      else
        if @course.errors.empty?
          # Potential Ajax implementation here!
          flash[:success] = "#{@course_set.first.subject} #{@course_set.first.number} 
          section #{@course_set.first.section} added."

          # Initialize notification attributes of the course selection
          CourseSelection.find_by(user_id: current_user.id, 
                                  course_id: @course.id).init_notification_attributes

          redirect_to user_path(current_user)
        else
          render 'new'
        end
      end
    end

  end

  def destroy
    course = CourseSelection.find(params[:id]).course
    current_user.unwatch!(course)
    flash[:warning] = "#{course.subject} #{course.number} section #{course.section} 
    removed from your watchlist."
    redirect_to user_path(current_user)
  end

  private

    # Before filters
    def signed_in_user
      unless signed_in?
        flash[:warning] = "Not authorized! Please sign in."
        redirect_to signin_path
      end
    end
end
