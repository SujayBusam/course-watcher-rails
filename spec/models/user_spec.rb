require 'spec_helper'

describe User do
  
  before { @user = User.new(name: "John Doe", 
                            email: 'user@example.com', 
                            password: "foobar",
                            password_confirmation: "foobar") }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }

  # Will not persist in database
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  # Course selection
  it { should respond_to(:course_selections) }
  it { should respond_to(:courses) }

  it { should be_valid }

  #### NAME ####

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = ('a' * 36 ) }
    it { should_not be_valid }
  end

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
    before do
      @user.password = @user.password_confirmation = " "
    end
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

  describe "when password is too long" do
    before { @user.password_confirmation = @user.password = 'a'*26 }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before do
      @user.password = "foobar"
      @user.password_confirmation = "foobar"
      @user.save
    end
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


  #### AUTHENTICATION #####

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end


  #### COURSE SELECTION #####

  describe "watching a course" do
    let(:course) { FactoryGirl.create(:course) }
    before do
      @user.save
      @user.watch!(course.subject, course.number)
    end

    it { should be_watching(course) }
    its(:courses) { should include(course) }

    describe "then removing course" do
      before { @user.unwatch!(course) }

      it { should_not be_watching(course) }
      its(:courses) { should_not include(course) }
    end
  end

  describe "creating a new course" do
    before do
      @user.save
      @user.courses.create!(subject: "COSC", number: 50)
    end
    let(:course) { @user.courses.find_by(subject: "COSC") }

    it { should be_watching(course) }
    its(:courses) { should include(course) }

    describe "then removing created course" do
      
    end
  end
end

