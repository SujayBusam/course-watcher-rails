require 'spec_helper'

describe "Authentication" do
  subject { page }
  
  describe "Sign in page" do
    before { visit signin_path }

    it { should have_title('Sign in') }
  end

  describe "signin action" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Login" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-danger') }

      describe "after visiting another page" do
        before { click_link "CourseWatch" }

        it { should_not have_selector('div.alert.alert-danger') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign Out', href: signout_path) }
      it { should_not have_link('SIGN IN', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign Out" }
        it { should have_link("Sign in") }
      end
    end
  end

  describe "authorization" do
    
    describe "for non-signed in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the users controller" do
        
        describe "visiting a user's show page" do
          before { visit user_path(user) }
          it { should have_title("Sign in") }
          it { should have_selector('div.alert.alert-warning') }
        end

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title("Sign in") }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          # it { should have_title("Sign in") }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user, no_capybara: true }

      describe "submitting a GET request to the Users#edit action" do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match('Edit user') }
        specify { expect(response).to redirect_to(root_url) }
        
      end

      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
        
      end
    end

  end
end
