namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    # make_course_selections
  end
end

def make_users
  10.times do |n|
    name  = Faker::Name.name
    email = "user#{n+1}@example.com"
    password  = "foobar"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_course_selections
  users = User.all
  10.times do |n|
    subject = course_subjects[n]
    number = n + 5
    users.each do |user|
      user.watch(subject, number)
    end
  end
end

# Helper
def course_subjects
  %w{ AAAS AMEL AMES ANTH ARAB ARTH ASTR BIOL CHEM CHIN CLST COCO COGS COLT COSC 
  EARS ECON EDUC ENGL ENGS ENVS FILM FREN FRIT FYS GEOG GERM GOVT GRK HEBR HIST
  HUM INTS ITAL HAPN JWST LACS LAT LATS LING M&SS MATH MUS NAS PBPL PHIL PHYS 
  PORT PSYC REL RUSS SART SOCY SPAN SPEE SSOC THEA TUCK WGST WPS WRIT }
end


