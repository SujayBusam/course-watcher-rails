class User < ActiveRecord::Base
  before_save { self.email = self.email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+\.[a-z]+\z/i

  has_secure_password

  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX},
                    uniqueness: { case_sensitive: false }

  # Presence validations for password and its confirmation automatically
  # added by has_secure_password
  validates :password, length: { minimum: 6, maximum: 25 }

end
