require 'rubygems'
require 'paperclip'
require 'active_record'
require 'action_view'

module SexItUp

  class SexItUpImage < ActiveRecord::Base
    include Paperclip::Glue

    attr_reader :sizes
    has_attached_file :image, :styles => Proc.new { |instance| instance.attachment_sizes }
    after_create  :reprocess
    after_destroy :reprocess


    # Want to give each user a unique avatar?  Assign their profile image to the image returned here.
    def self.find_all(term)
      query = "site:commons.wikimedia.org \"is in the public domain\" #{term}"
      cache_search(query)
    end

    private
    def self.cache_search(query)
      images = []
      Google::Search::Web.new(:query => query).each do |result|
        page        = agent.get(result.uri)
        image       = find_image_link(page)

        images << cache(query, image)
      end

    end

    def find_image_link(page)
      page.links.detect {|link| link.href =~ /http:\/\/upload.wikimedia.org\/wikipedia\/commons\/\w\// }
    end

    def self.agent
      @agent||= Mechanize.new
      @agent.max_history = 1
      @agent.user_agent_alias = 'Mac Safari'
      @agent
    end

    def self.cache(search_term, img_url)
      # No need to re-retrieve file if already done so
      image = find_by_original_image_url(img_url)
      return image unless image.nil?

      image = open img_url
      SexItUpImage.create(:image_original_url => img_url,
                          :image_search_term => search_term,
                          :image => image)
    end

    def attachment_sizes
      sizes = {:thumb => ["100x100"]}
      self.sizes.each do |size|
        sizes[:"#{size.id}"] = ["#{size.width}x#{size.height}"]
      end

      sizes
    end


#    def reprocess
#      self.image.reprocess!
#    end

  end


  module SexItUpViewHelper

    # Searches wikimedia for passed in term.  Caches all initial results.
    #  As you search through results, image files will generally follow the form e.g. "File:<image name>.jpg - Wikimedia Commons"
    # Retains the original image and will generate scaled versions based on coordinates passed in
    # Allow for an optional watermark that defaults to the text "Placeholder"
    def sexy_image(term, opts = {})

       image_tag
    end

  end

end

ActionView::Base.send :include, SexItUp::SexItUpViewHelper
