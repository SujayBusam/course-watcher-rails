class UserMailer < ActionMailer::Base
  default from: "mailer@coursewatch.com"

  def course_notification_email(user, course)
    @user = user
    @course = course
    mail(to: @user.email, subject: "Your course is available!")
  end
end
