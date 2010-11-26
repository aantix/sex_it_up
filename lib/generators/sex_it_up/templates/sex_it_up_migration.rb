require 'sex_it_up'

class CreateSexItUpImages < ActiveRecord::Migration
  def self.up
    #load(File.dirname(__FILE__) + '/../../../spec/schema.rb')
    create_table "sex_it_up_images" do |t|
      t.string :image_search_term
      t.string :image_original_url
      t.string :image_url
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
    end

  end

  def self.down
    drop_table :sex_it_up_images
  end

end
