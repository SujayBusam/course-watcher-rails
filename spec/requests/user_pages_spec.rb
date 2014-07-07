require 'spec_helper'

describe "UserPages" do
  let(:base_title) { "CourseWatch" }  
  subject { page } 

  describe "Signup page" do
    before { visit new_user_path }
    let(:submit) { 'Submit' }

    it { should have_content('Sign up') }
    it { should have_button(submit) }
    it { should have_title("#{base_title} | Sign Up")}

    describe "With invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "With password too short" do
      before do
        fill_in "inputEmail", with: 'user@example.com'
        fill_in "inputPassword", with: 'fooba'
        fill_in "inputConfirmation", with: 'fooba'
      end
      
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "With password too long" do
      before do
        fill_in "inputEmail", with: 'user@example.com'
        fill_in "inputPassword", with: ('f' * 26)
        fill_in "inputConfirmation", with: ('f' * 26)
      end
      
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "With valid information" do
      before do
        fill_in "inputEmail", with: 'user@example.com'
        fill_in "inputPassword", with: 'foobar'
        fill_in "inputConfirmation", with: 'foobar'
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end


