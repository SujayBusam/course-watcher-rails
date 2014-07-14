class Course < ActiveRecord::Base
  # Database associations
  has_many :course_selections
  has_many :users, through: :course_selections

  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :subject, uniqueness: { scope: :number },
                      presence: true,
                      inclusion: { in:  %w{ AAAS AMEL AMES ANTH ARAB ARTH ASTR BIOL CHEM CHIN CLST COCO COGS COLT COSC 
      EARS ECON EDUC ENGL ENGS ENVS FILM FREN FRIT FYS GEOG GERM GOVT GRK HEBR HIST
      HUM INTS ITAL HAPN JWST LACS LAT LATS LING M&SS MATH MUS NAS PBPL PHIL PHYS 
      PORT PSYC REL RUSS SART SOCY SPAN SPEE SSOC THEA TUCK WGST WPS WRIT }, 
                                   message: "is not valid." }

  # Course selection methods

  def watched_by?(user)
    self.course_selections.find_by(user_id: user.id)
  end
  
  def Course.get_subjects
    %w{ AAAS AMEL AMES ANTH ARAB ARTH ASTR BIOL CHEM CHIN CLST COCO COGS COLT COSC 
      EARS ECON EDUC ENGL ENGS ENVS FILM FREN FRIT FYS GEOG GERM GOVT GRK HEBR HIST
      HUM INTS ITAL HAPN JWST LACS LAT LATS LING M&SS MATH MUS NAS PBPL PHIL PHYS 
      PORT PSYC REL RUSS SART SOCY SPAN SPEE SSOC THEA TUCK WGST WPS WRIT }
  end
end
