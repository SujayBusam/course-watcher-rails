class CourseSelection < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :user, presence: true
  validates :course, presence: true

  def init_notification_attributes
    if self.course.available?
      self.update_attributes(user_needs_notified: false,
                             course_initially_available: true)
    end
  end

  # Email necessary users if their course is available
  def self.notify_users
    CourseSelection.all.each do |course_selection|
      if course_selection.course.available?
        # Email the user if needed
        if course_selection.user_needs_notified
          UserMailer.course_notification_email(course_selection.user,
                                               course_selection.course).deliver
          course_selection.user_needs_notified = false
        end
      else
        if course_selection.course_initially_available
          course_selection.user_needs_notified = true
        end
      end
    end
  end

end
