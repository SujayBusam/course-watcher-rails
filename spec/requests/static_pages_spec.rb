require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { 'CourseWatch'}
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('CourseWatch')}
    it { should have_title("#{base_title} | Home")}  
  end
end
