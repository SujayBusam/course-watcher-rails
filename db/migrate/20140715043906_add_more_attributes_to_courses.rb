class AddMoreAttributesToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :period, :string
    add_column :courses, :distrib, :string
  end
end
