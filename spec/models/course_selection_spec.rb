require 'spec_helper'
require 'pp'

describe CourseSelection do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:course) { FactoryGirl.create(:course) }
  let(:course_selection) { user.course_selections.build(course_id: course.id) }

  subject { course_selection }

  it { should be_valid }

  describe "user-course methods" do
    it { should respond_to(:user) }
    it { should respond_to(:course) }
    its(:user) { should eq user }
    its(:course) { should eq course }
  end

  describe "when user id is not present" do
    before { course_selection.user = nil } 
    it { should_not be_valid }
  end
  
  describe "when course id is not present" do
    before { course_selection.course = nil }
    it { should_not be_valid }
  end
end
