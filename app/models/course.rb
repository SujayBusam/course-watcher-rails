class Course < ActiveRecord::Base
  validates :subject, presence: true
  validates :number, presence: true
end
