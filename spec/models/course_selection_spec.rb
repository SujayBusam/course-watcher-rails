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
    it { should respond_to(:user_needs_notified) }
    it { should respond_to(:course_initially_available) }

    its(:user) { should eq user }
    its(:course) { should eq course }
    its(:user_needs_notified) { should be_true }
    its(:course_initially_available) { should be_false }
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
