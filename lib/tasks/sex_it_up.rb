require 'sex_it_up'

namespace :sex_it_up do

  desc "Retrieve and cache all of the public domain images for a given search term."
  task :cache, :term, :needs => :environment do |t, args|
    SexItUp::SexItUp.find_all(args[:term])
  end

end
