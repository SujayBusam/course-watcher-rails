class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }
  before_create :create_remember_token

  # Database associations
  has_many :course_selections
  has_many :courses, through: :course_selections, dependent: :destroy

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i

  has_secure_password

  validates :name, presence: true, length: { maximum: 35 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }

  # Presence validations for password and its confirmation automatically
  # added by has_secure_password
  validates :password, length: { minimum: 6, maximum: 25 }

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # Course selection methods

  def watch!(course)
    self.course_selections.create!(course_id: course.id)
  end

  def unwatch!(course)
    self.course_selections.find_by(course_id: course.id).destroy
  end

  def watching?(course)
    self.course_selections.find_by(course_id: course.id)
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
