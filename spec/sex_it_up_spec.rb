#require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
ROOT_DIR = `pwd`.strip unless defined? ROOT_DIR
require ROOT_DIR + '/spec/spec_helper'

describe SexItUp::SexItUpImage, '#find_all' do

  it "shouldn't have any images cached" do
    SexItUp::SexItUpImage.all.should have(0).things
  end

  it "should cache at least one image for the search term 'school'" do
    SexItUp::SexItUpImage.find_all('school')
    SexItUp::SexItUpImage.all.should have_at_least(1).things
  end

  it "should find the 'Plato and Aristotle in The School of Athens' image'" do
    @image = Factory.build(:sex_it_up_image)

    url = 'http://upload.wikimedia.org/wikipedia/commons/f/ff/Plato_and_Aristotle_in_The_School_of_Athens%2C_by_italian_Rafael.jpg'
    SexItUp::SexItUpImage.find_by_image_original_url(url).image_original_url.should == @image.image_original_url
  end

  it "should return an empty series of SexItUpImage objects" do
    SexItUp::SexItUpImage.find_all('blah123xyz').should == []
  end

end
