puts 'SETTING UP DEFAULT USER LOGIN'
user = User.create! :name => 'Super Admin', :email => 'admin@pernix-solutions.com', :password => '123456', :password_confirmation => '123456', :rol_id => 1
puts 'Nuevo usuario creado: ' << user.name
puts 'SETTING UP SOCIAL NETWORKS'
social = InfoSocialNetwork.create! :name => 'Facebook', :description => "Red Social Facebook", :id_name => "facebook" 
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Twitter', :description => "Red Social Twitter", :id_name => "twitter"
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Linkedin', :description => "Red Social Linkedin", :id_name => "linkedin"
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Pinterest', :description => "Red Social Pinterest", :id_name => "pinterest"
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Youtube', :description => "Red Social Youtube", :id_name => "youtube"
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Tuenti', :description => "Red Social Tuenti", :id_name => "tuenti"
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Flickr', :description => "Red Social Flickr", :id_name => 'flickr'
