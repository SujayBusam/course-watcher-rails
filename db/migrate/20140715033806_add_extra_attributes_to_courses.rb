class AddExtraAttributesToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :crn, :integer
    add_column :courses, :section, :integer
    add_column :courses, :title, :string
    add_column :courses, :cross_list, :string
    add_column :courses, :room, :string
    add_column :courses, :building, :string
    add_column :courses, :instructor, :string
    add_column :courses, :world_culture, :string
    add_column :courses, :limit, :integer
    add_column :courses, :enrollment, :integer
    add_column :courses, :status, :string
  end
end
