ROOT_DIR = `pwd`.strip unless defined? ROOT_DIR
require ROOT_DIR + '/spec/spec_helper'

describe SexItUp::SexItUpHelper do
  include SexItUp::SexItUpHelper

  before(:all) do
    # Start with a clean slate
    SexItUp::SexItUpImage.delete_all
    @image = Factory.build(:sex_it_up_image)
  end

  describe "sexy_image" do
    it "should source a random image for the search term and size it accordingly" do
      sexy_image('school', {:width => 50, :height => 50}).should =~ /.jpg/i
      sexy_image('school', {:width => 50, :height => 50}).should =~ /s_50x50/
    end

    it "should generate an image tag for the Rafael.jpg image " do
      sexy_image(@image, {:width => 50, :height => 50}).should =~ /s_50x50\/Plato_and_Aristotle_in_The_School_of_Athens,_by_italian_Rafael.jpg/
    end

  end

end
