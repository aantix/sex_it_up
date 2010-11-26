require 'rails/generators'
require 'rails/generators/migration'

class SexItUpGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  #source_root = File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  def self.source_root
     @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  def generate_migration
    migration_template "sex_it_up_migration.rb", "db/migrate/create_sex_it_up_images.rb"
  end

  protected

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

end