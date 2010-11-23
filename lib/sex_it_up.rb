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
      query = "site:commons.wikimedia.org \"is in the public domain\" #{term}"
      cache_search(query, term)
    end

    def set_attachment_sizes(sizes = {:thumb => ["100x100"]})
      @sizes = sizes
    end

    def attachment_sizes
      @sizes||={:thumb => ["100x100"]}
    end

    private
    def self.cache_search(query, term)
      images      = []
      num_results = 0

      Google::Search::Web.new(:query => query).each do |result|
        page        = agent.get(result.uri)
        image       = find_image_link(page)

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
      # No need to re-retrieve file if already done so
      image = find_by_image_original_url(img_url)
      return image unless image.nil?

      #image = open img_url
      image = open(URI.parse(img_url))

      # The original_filename passed in from a file open is unintelligible;
      #   change it to something better. Feels 'dirty' but admittance is the first step.
      def image.original_filename; base_uri.path.split('/').last; end
      image.original_filename.blank? ? nil : image

      SexItUpImage.create!(:image_original_url => img_url,
                           :image_search_term => search_term,
                           :image => image)
    end

  end


  module SexItUpHelper
    # Pass in a search term (e.g. 'dogs') and the resolution you
    #  want the image to be displayed at.
    def sexy_image(term, opts = {:width => 100, :height => 100})

      # The loving is a mess, what happened to all of the feeling?
      # I thought it was for real; babies, rings and fools kneeling
      # And words of pledging trust and lifetimes stretching forever
      # So what went wrong? It was a lie, it crumbled apart
      # Ghost figures of past, present, future haunting the heart
      sexy_image = term.class == SexItUp::SexItUpImage ? term : SexItUpImage.where(['image_search_term = ?', term]).random.first

      if sexy_image.nil? || sexy_image.blank?
        # No image object passed in or found; let's go search.

        SexItUpImage.find_all(term)
        sexy_image = SexItUpImage.where(['image_search_term = ?', term]).random.first
      end

      unless sexy_image.nil?
        style           = "#{opts[:width]}x#{opts[:height]}"
        style_sym       = "s_#{style}".to_sym
        style_hash      = {style_sym => [style]}

        sexy_image.set_attachment_sizes(style_hash)
        sexy_image.image.reprocess! unless File.exist?(sexy_image.image.path(style_sym))

        tag = "<img"
        tag += " class=\"#{opts[:class]}\"" if opts[:class]
        tag += " src=\"#{sexy_image.image.url(style_sym)}\""
        tag += " alt=\"#{opts[:alt]}\"" if opts[:alt]
        tag += " title=\"#{opts[:title]}\"" if opts[:title]
        tag += " />"

        return tag
      end

      nil
    end

  end

end

ActionView::Base.send :include, SexItUp::SexItUpHelper
