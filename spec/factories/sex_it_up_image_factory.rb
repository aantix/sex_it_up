Factory.define :sex_it_up_image, :class => SexItUp::SexItUpImage do |i|
  #i.image File.new('spec/factories/Plato_and_Aristotle_in_The_School_of_Athens,_by_italian_Rafael.jpg')
  #i.attachment(:image, "spec/factories/Plato_and_Aristotle_in_The_School_of_Athens.jpg", "image/jpeg")
  i.image { File.new("#{ROOT_DIR}/spec/factories/Plato_and_Aristotle_in_The_School_of_Athens,_by_italian_Rafael.jpg") }
  i.image_original_url 'http://upload.wikimedia.org/wikipedia/commons/f/ff/Plato_and_Aristotle_in_The_School_of_Athens%2C_by_italian_Rafael.jpg'
  i.image_search_term 'school'
end
