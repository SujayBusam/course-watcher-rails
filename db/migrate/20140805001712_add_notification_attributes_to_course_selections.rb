class AddNotificationAttributesToCourseSelections < ActiveRecord::Migration
  def change
    add_column :course_selections, :course_initially_available, :boolean, default: false
    add_column :course_selections, :user_needs_notified, :boolean, default: true
  end
end
