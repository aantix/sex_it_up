#require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
ROOT_DIR = `pwd`.strip unless defined? ROOT_DIR
require ROOT_DIR + '/spec/spec_helper'

describe SexItUp::SexItUpImage, '#find_all' do

  before(:each) do
    @image = Factory.create(:sex_it_up_image)
  end

  it "shouldn't have anything cached to begin with" do
    SexItUp::SexItUpImage.should have(0).things
  end

  it "should cache at least one image for the search term 'school'" do
    SexItUp::SexItUpImage.find_all('school')
    SexItUp::SexItUpImage.should have_at_least(1).things
  end

  it "should find the 'Plato and Aristotle in The School of Athens' image'" do
    SexItUp::SexItUpImage.find_all('school').should include @image
  end

  it "should return an empty series of SexItUpImage objects" do
    SexItUp::SexItUpImage.find_all('blah123xyz').should be []
  end

end
