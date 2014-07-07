require 'spec_helper'

describe "UserPages" do

  describe "Singup page" do
    before { visit new_user_path }
    let(:submit) { 'Submit' }

    it { should have_button('Sign up') }

    describe "With invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "With valid information" do
      before do
        fill_in "inputDefault", with: "user@example.com"
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end

end


