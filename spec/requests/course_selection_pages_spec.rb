require 'spec_helper'

describe "CourseSelectionPages" do
  let(:user) { FactoryGirl.create(:user) }
  subject { page }
  let(:add_course) { "Add course" }
  let(:delete_course) { "Unwatch Course" }

  ##### NEW COURSE SELECTION ######

  describe "new course selection page" do
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

    describe "trying to watch a course with multiple sections" do
      before do
        fill_in "inputSubject", with: "ECON"
        fill_in "inputNumber", with: 1
        click_button(add_course)
      end

      it { should have_title("New Course") }
      it { should have_content("ECON 1") }
      it { should have_content("Section") }
    end

    # Valid course selection
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
    
  end

  ##### COURSE SELECTION SHOW ######

  describe "show page" do
    before do
      sign_in user
      visit new_course_selection_path
      fill_in "inputSubject", with: "COSC"
      fill_in "inputNumber", with: "30"
      click_button(add_course)
      click_link('More info')
    end

    it { should have_title("COSC 30") }
    it { should have_button(delete_course) }

    describe "clicking the delete course button" do
      
      it "should delete the course from the user's course selections" do
        expect { click_button delete_course }.to change(user.courses, :count).by(-1)
      end

      it "should not delete the actual course from the database" do
        expect { click_button delete_course }.not_to change(Course.all, :count)
      end
    end 
  end

end
