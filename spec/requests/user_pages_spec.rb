require 'spec_helper'

describe "UserPages" do
  let(:base_title) { "CourseWatch" }  
  subject { page } 

  ###### SIGNUP ######

  describe "Signup page" do
    before { visit new_user_path }
    let(:submit) { 'Submit' }

    it { should have_content('Sign up') }
    it { should have_button(submit) }
    it { should have_title("#{base_title} | Sign Up") }

    describe "With invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "With password too short" do
      before do
        fill_in "inputName", with: 'John Doe'
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
        fill_in "inputName", with: 'John Doe'
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
        fill_in "inputName", with: 'John Doe'
        fill_in "inputEmail", with: 'user@example.com'
        fill_in "inputPassword", with: 'foobar'
        fill_in "inputConfirmation", with: 'foobar'
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }
        
        it { should have_content(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  #### PROFILE PAGE #####

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_content(user.name) }
    it { should have_content(user.email) }
  end


  #### EDIT PAGE #####

  describe "edit page" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }
    before { visit edit_user_path(user) }

    it { should have_title("Edit") }

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_selector('div.alert.alert-danger') }
    end

    describe "with valid information" do
      let(:new_email) { "new@example.com" }
      before do
        fill_in "inputEmail",            with: new_email
        fill_in "inputPassword",         with: user.password
        fill_in "inputConfirmation",     with: user.password
        click_button "Save changes"
      end

      it { should have_selector('div.alert.alert-success') }
      # it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.email).to eq new_email }
    end
  end
end


