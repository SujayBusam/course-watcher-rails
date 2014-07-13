require 'spec_helper'

describe Course do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @course = Course.new(subject: "COSC", number: 10) }

  subject { @course }

  it { should respond_to(:subject) }
  it { should respond_to(:number) }

  it { should respond_to(:course_selections) }
  it { should respond_to(:users) }

  describe "when a duplicate course is created" do
    before do
      duplicate_course = @course.dup
      duplicate_course.save
    end

    it { should_not be_valid }
  end

  ###### COURSE SUBJECT ######

  describe "when subject is not present" do
    before { @course.subject = " " }
    it { should_not be_valid }
  end

  ###### COURSE NUMBER #######

  describe "when number is not present" do
    before { @course.number = " " }
    it { should_not be_valid }
  end

  ##### COURSE SELECTION #####

  # describe "course selection" do
  #   before { user.watch!(@course.subject, @course.number) }

  #   it { should be_watched_by(user) }
  #   its(:users) { should include(user) }
  # end
end
