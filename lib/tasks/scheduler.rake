include pp

desc "Task called by Heroku scheduler add-on"

task update_course_attributes: :environment do
  puts "Updating course stats..."
  Course.update_courses_stats
  puts "done."

  puts "Notifying users..."
  CourseSelection.notify_users
  puts "done."
end