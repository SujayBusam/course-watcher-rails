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

  def watch(course_subject, course_number, course_section=nil)
    if course_section
      course_set = Course.where(subject: course_subject, 
                                number: course_number,
                                section: course_section)
      self.course_selections.create(course_id: course_set.first.id)
      return course_set
    else
      # Check if any courses with given subj and number are in database
      course_set = Course.where(subject: course_subject, number: course_number)

      if course_set.empty?
        # No matching courses in database, so validate and initialize all 
        # sections of this course
        course_set = Course.validate_and_init(course_subject, course_number)

        if course_set
          # Validation successful. Create the course selection of there is one section
          # and return the set of courses (all sections)
          if course_set.count == 1
            course_built = course_set.first
            course_in_db = Course.find_by(subject: course_built.subject,
                                          number: course_built.number,
                                          section: course_built.section)
            self.course_selections.create(course_id: course_in_db.id)
          end
          return course_set
        else
          # Validation not successful. Return a course object with an error
          course_set = Array.new
          course = Course.create(subject: course_subject, number: course_number)
          if course.errors.empty?
            course.errors.add(:base, "#{course_subject} #{course_number} 
                            isn't a valid course this term.")
            Course.find_by(subject: course_subject, number: course_number).destroy
          end
          course_set.push(course)
        end
      else
        if course_set.count > 1
          # Multiple sections. Return the set of all of them
          return course_set
        else
          # Only one section. Create the course selection and return the course set
          course = course_set.first
          self.course_selections.create(course_id: course.id)
          return course_set
        end
      end
    end
  end

  def unwatch!(other_course)
    self.course_selections.find_by(course_id: other_course.id).destroy
  end

  def watching?(other_course)
    self.course_selections.find_by(course_id: other_course.id)
  end

  # # Return false if course doesn't exist in db, return set of courses if there 
  # # are multiple sections of this course, return a set of courses containing 
  # # one course (the course) if user is following it (only one section of it), or
  # # return nil if the user isn't following the course (that has only one section)
  # def watching_course?(course_subject, course_number)
  #   course_set = Course.where(subject: course_subject, number: course_number)
  #   if course_set.empty?
  #     return false
  #   else
  #     if course_set.count > 1
  #       return course_set
  #     else
  #       if self.watching?(course_set.first)
  #         return course_set
  #       else
  #         return false
  #     end
  #   end
  # end

  # Above was the proposed return types, but ruby was not doing what I expected.
  # 
  # Return false for a course not in db, nil if course is in db but user isn't
  # following it, a CourseSelection if course is in db and user is following it,
  # and an ActiveRecord::Relation (set of courses) if there are multiple sections
  # of the course
  def watching_course?(course_subject, course_number, course_section)
    if course_section
      course = Course.find_by(subject: course_subject, 
                              number: course_number,
                              section: course_section)
      self.watching?(course)
    else
      course_set = Course.where(subject: course_subject, number: course_number)

      unless course_set.empty?
        self.watching?(course_set.first) unless course_set.count > 1
      end
    end
  end


  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
