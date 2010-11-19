ROOT_DIR = `pwd`.strip unless defined? ROOT_DIR
require ROOT_DIR + '/spec/spec_helper'

describe SexItUp::SexItUpHelper do
  include SexItUp::SexItUpHelper

  describe "sexy_image" do
    it "should equal 'yes'" do
      sexy_image('dog').should == 'yes'
    end
  end

end
