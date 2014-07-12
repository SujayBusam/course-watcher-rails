require 'spec_helper'

describe Course do
  
  let(:user) { FactoryGirl.create(:user) }
  before { @course = Course.new(subject: "COSC", number: 10) }

  subject { @course }

  it { should respond_to(:subject) }
  it { should respond_to(:number) }

  it { should respond_to(:course_selections) }
  it { should respond_to(:users) }

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

  describe "course selection" do
    before do
      @course.save
      user.watch!(@course)
    end

    it { should be_watched_by(user) }
    its(:users) { should include(user) }
  end
end
