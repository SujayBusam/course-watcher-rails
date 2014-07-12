class CreateCourseSelections < ActiveRecord::Migration
  def change
    create_table :course_selections do |t|
      t.integer :user_id
      t.integer :course_id

      t.timestamps
    end

    add_index :course_selections, :user_id
    add_index :course_selections, :course_id
    add_index :course_selections, [:user_id, :course_id], unique: true
  end
end
