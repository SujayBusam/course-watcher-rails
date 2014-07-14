require 'spec_helper'

describe "CourseSelectionPages" do
  subject { page }

  describe "new course selection page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit new_course_selection_path(user_id: user.id)
    end 

    it { should have_title('New Course') }
    
    describe "with no info filled in" do
      it "should not create a course selection" do
        expect { click_button 'Add course' }.not_to change(CourseSelection, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "inputSubject", with: "COSC"
        fill_in "inputNumber", with: "50"
      end

      it "should create a course selection" do
        expect { click_button 'Add course' }.to change(CourseSelection, :count).by(1)
      end
    end
  end
end
