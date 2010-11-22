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

DB = '/tmp/sex_it_up.sqlite'

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

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/helpers/**/*.rb"].each {|f| require f}

# Factories aren't autodiscovered in non-rails environments so have to
#  explicitly find them.
Factory.find_definitions

RSpec.configure do |config|
  config.mock_with :rspec
end


