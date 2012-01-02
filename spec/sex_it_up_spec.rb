#require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
ROOT_DIR = `pwd`.strip unless defined? ROOT_DIR
require ROOT_DIR + '/spec/spec_helper'

describe SexItUp::SexItUpImage do
  before(:all) do
    # Start with a clean slate
    SexItUp::SexItUpImage.delete_all

    @data =  json_fixture('school_results')
  end
  
  before(:each) do
    Google::Search::Web.any_instance.stubs(:get_raw).returns(@data)
  end

  it "shouldn't have any images cached" do
    SexItUp::SexItUpImage.count.should == 0
  end

  it "should cache at least one image for the search term 'school'" do
    SexItUp::SexItUpImage.find_all('school')
    SexItUp::SexItUpImage.count.should == 1
  end

  it "should find the 'Plato and Aristotle in The School of Athens' image'" do
    @image = Factory.create(:sex_it_up_image)

    url = 'http://upload.wikimedia.org/wikipedia/commons/f/ff/Plato_and_Aristotle_in_The_School_of_Athens%2C_by_italian_Rafael.jpg'
    SexItUp::SexItUpImage.find_by_image_original_url(url).image_original_url.should == @image.image_original_url
  end

  it "should return an empty series of SexItUpImage objects" do
    SexItUp::SexItUpImage.find_all('blah123xyz').should == []
  end

end
