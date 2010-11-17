$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'sex_it_up'
require 'factory_girl'

require 'active_record'
require 'active_support'
require 'logger'

require 'initializers/paperclip'

gem 'sqlite3-ruby'

DB = '/tmp/jobs.sqlite'

File.delete(DB) rescue nil
ActiveRecord::Base.logger = Logger.new('/tmp/sex_it_up.log')
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => DB)

ActiveRecord::Schema.define(:version => 1) do
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


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Factory.find_definitions

RSpec.configure do |config|
  config.mock_with :rspec
end


