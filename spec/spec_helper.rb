$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'sex_it_up'
require 'factory_girl'

require 'active_record'
require 'active_support'
require 'logger'
require 'randumb'

require 'initializers/paperclip'

gem 'sqlite3-ruby'

DB = '/tmp/sex_it_up.sqlite'

def fixture path
  File.read File.dirname(__FILE__) + "/fixtures/#{path}"
end

def json_fixture name
  fixture("#{name}.json")
end

RSpec.configure do |config|
  config.mock_with :mocha
end

# Delete the db if exists so we have a clean slate to run against.
File.delete(DB) rescue nil

# Delete the paperclip cache directory
FileUtils.rm_rf('public')

ActiveRecord::Base.logger = Logger.new('/tmp/sex_it_up.log')
ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => DB)

ActiveRecord::Schema.define(:version => 1) do
  ActiveRecord::Migration.verbose = false
  load(File.dirname(__FILE__) + '/schema.rb')
end

Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each {|f| require f}

FactoryGirl.find_definitions


