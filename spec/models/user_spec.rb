require 'spec_helper'

describe User do
  
  before { @user = User.new(email: 'user@example.com', password: "foobar",
                            password_confirmation: "foobar") }
  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:authenticate) }

  # Will not persist in database
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  ##### EMAIL #####
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when email has invalid format" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
        foo@bar_baz.com foo@bar+baz.com foo@bar..com]

      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end


  #### PASSWORD #####
  describe "when password is not present" do
    before { @user = User.new(email: 'foobar@example.com', password: " ",
                              password_confirmation: " ") }
    it { should_not be_valid }  
  end

  describe "when password doesn't match confirmation" do
    before { @user.password = 'mismatch' }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password_confirmation = @user.password = 'a'*5 }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password_confirmation = @user.password = 'a'*26 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_with_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_with_invalid_password }
      specify { expect(user_with_invalid_password).to be_false }
    end
  end

end

