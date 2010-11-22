require 'rubygems'
require 'paperclip'
require 'active_record'
require 'action_view'
require 'google-search'
require 'mechanize'
require 'open-uri'


Paperclip.configure
Paperclip::Railtie.insert

module SexItUp

  class SexItUpImage < ActiveRecord::Base
    RESULT_LIMIT = 3

    scope :random, lambda {
      max_id  = connection.select_value("select max(id) from #{self.table_name}")
      where("id >= #{rand(max_id)}")
    }

    attr_reader :sizes
    has_attached_file :image, :styles => Proc.new { |i| i.instance.attachment_sizes }

    # Want to give each user a unique avatar?  Assign their profile image to the image returned here.
    def self.find_all(term)
      puts "Querying....."
      query = "site:commons.wikimedia.org \"is in the public domain\" #{term}"
      cache_search(query, term)
    end

    def set_attachment_sizes(sizes = {:thumb => ["100x100"]})
      puts "attachment_sizes = #{sizes.inspect}"
      @sizes = sizes
    end

    def attachment_sizes
      @sizes||={:thumb => ["100x100"]}
    end

    private
    def self.cache_search(query, term)
      images      = []
      num_results = 0

      puts "Caching results..."
      Google::Search::Web.new(:query => query).each do |result|
        puts "Result : [#{result.uri}]"
        page        = agent.get(result.uri)
        image       = find_image_link(page)

        puts "image = #{image.inspect}"

        images << cache(term, image.href) unless image.nil?

        num_results+=1
        break if num_results == RESULT_LIMIT
      end

      images
    end

    def self.find_image_link(page)
      page.links.detect {|link| link.href =~ /http:\/\/upload.wikimedia.org\/wikipedia\/commons\/\w\// }
    end

    def self.agent
      @agent||= Mechanize.new
      @agent.max_history = 1
      @agent.user_agent_alias = 'Mac Safari'
      @agent
    end

    def self.cache(search_term, img_url)
      puts "-- img_url = #{img_url}"

      # No need to re-retrieve file if already done so
      image = find_by_image_original_url(img_url)
      return image unless image.nil?

      #image = open img_url
      image = open(URI.parse(img_url))
      def image.original_filename; base_uri.path.split('/').last; end
      image.original_filename.blank? ? nil : image

      SexItUpImage.create!(:image_original_url => img_url,
                           :image_search_term => search_term,
                           :image => image)
    end

  end


  module SexItUpHelper
    include ActionView::Helpers::AssetTagHelper

    # Pass in a search term (e.g. 'dogs') and the resolution you
    #  want the image to be displayed at.
    def sexy_image(term, opts = {:width => 100, :height => 100})
      sexy_image      = SexItUpImage.where(['image_search_term = ?', term]).random.first

      if sexy_image.nil? || sexy_image.empty?
        # No images for a given term; let's go find some.

        SexItUpImage.find_all(term)
        sexy_image = SexItUpImage.where(['image_search_term = ?', term]).random.first
      end

      unless sexy_image.nil?
        style           = "#{opts[:width]}x#{opts[:height]}"
        style_sym       = "s_#{style}".to_sym
        style_hash      = {style_sym => [style]}

        sexy_image.set_attachment_sizes(style_hash)
        sexy_image.image.reprocess! # unless File.exist?(sexy_image.image.path(style_sym))

        return sexy_image.image.url(style_sym)
        #return image_tag(sexy_image.image.url(style.to_sym))
      end

      nil
    end

  end

end

ActionView::Base.send :include, SexItUp::SexItUpHelper
