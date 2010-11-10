require 'rubygems'
require 'socket'
require 'lockfile'
require 'active_record'
require 'action_view'
require 'active_support'
require 'action_controller'

module SexItUp

  class SexItUpImage < ActiveRecord::Base
    # Want to give each user a unique avatar?  Assign their profile image to the image returned here.
    def self.find_all(term)
    end

  end


  module SexItUpViewHelper

    # Searches wikimedia for passed in term.  Caches all initial results.
    #  As you search through results, image files will generally follow the form e.g. "File:<image name>.jpg - Wikimedia Commons"
    # Retains the original image and will generate scaled versions based on coordinates passed in
    # Allow for an optional watermark that defaults to the text "Placeholder"
    def sexy_image(term, opts = {})

    end

  end

end

ActionView::Base.send :include, SexItUp::SexItUpFormHelper
