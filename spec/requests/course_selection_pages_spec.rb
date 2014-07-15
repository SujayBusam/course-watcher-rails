require 'spec_helper'

describe "CourseSelectionPages" do
  subject { page }
  let(:add_course) { "Add course" }

  describe "new course selection page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit new_course_selection_path
    end 

    it { should have_title('New Course') }
    
    describe "with no info filled in" do
      it "should not create a course selection" do
        expect { click_button add_course }.not_to change(CourseSelection, :count)
      end
    end

    describe "with no subject" do
      before { fill_in "inputNumber", with: "50" }

      it "should not create a course selection" do
        expect { click_button add_course }.not_to change(CourseSelection, :count)
      end

      describe "should cause page alert" do
        before { click_button(add_course) }

        it { should have_selector('div.alert.alert-danger') }
      end
    end

    describe "with invalid course selection" do
      before do
        fill_in "inputSubject", with: "COSC"
        fill_in "inputNumber", with: "300"
      end

      it "should not create a course selection" do
        expect { click_button add_course }.not_to change(CourseSelection, :count)
      end

      describe "should alert user" do
        before { click_button(add_course) }

        it { should have_selector('div.alert.alert-danger') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "inputSubject", with: "COSC"
        fill_in "inputNumber", with: "30"
      end

      it "should create a course selection" do
        expect { click_button add_course }.to change(CourseSelection, :count).by(1)
      end

      describe "should redirect to user show page" do
        before { click_button(add_course) }

        it { should have_title(user.name) }
      end
    end

    describe "trying to add same course twice" do
      before do
        2.times do
          visit new_course_selection_path
          fill_in "inputSubject", with: "COSC"
          fill_in "inputNumber", with: "30"
          click_button(add_course)
        end
      end

      it "should not create a course selection" do
        expect { click_button add_course }.not_to change(CourseSelection, :count)
      end

      describe "should alert user" do
        before { click_button(add_course) }

        it { should have_selector('div.alert.alert-danger') }
      end

    end
  end
end
