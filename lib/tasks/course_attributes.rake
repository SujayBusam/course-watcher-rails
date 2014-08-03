desc "Task called by Heroku scheduler add-on"

task update_course_attributes: :environment do
  Course.update_courses_stats
end