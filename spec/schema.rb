ActiveRecord::Schema.define :version => 0 do
  create_table "sex_it_up_images" do |t|
    t.string   :image_search_term
    t.string   :image_original_url
    t.string   :image_url
    t.string   :image_file_name
    t.string   :image_content_type
    t.integer  :image_file_size
    t.datetime :image_updated_at
  end

end