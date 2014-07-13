class Course < ActiveRecord::Base
  # Database associations
  has_many :course_selections
  has_many :users, through: :course_selections

  validates :subject, presence: true
  validates :number, presence: true
  validates :subject, uniqueness: { scope: :number }

  # Course selection methods

  def watched_by?(user)
    self.course_selections.find_by(user_id: user.id)
  end
  
end
