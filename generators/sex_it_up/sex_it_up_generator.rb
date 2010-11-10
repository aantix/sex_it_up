class SexItUpGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.migration_template "sex_it_up_migration.rb.erb", File.join('db', 'migrate'), :migration_file_name => 'create_sex_it_up_images'
    end
  end

  def banner
    %{Usage: #{$0} #{spec.name}\nCopies needed migrations to project.}
  end

end