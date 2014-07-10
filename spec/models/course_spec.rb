require 'spec_helper'

describe Course do
  
  before do
    @course = Course.new(subject: "COSC", number: 10)
  end

  subject { @course }

  it { should respond_to(:subject) }
  it { should respond_to(:number) }

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
end
