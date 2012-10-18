# encoding: utf-8
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
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Google+', :description => "Red Social Google+", :id_name => 'google_plus'
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Blog', :description => "Blogs", :id_name => 'blog'
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Tumblr', :description => "Red Social Tumblr", :id_name => 'tumblr'
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Campaña', :description => "Red Social Campaña", :id_name => 'campaign'
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Foursquare', :description => "Red Social Foursquare", :id_name => 'foursquare'
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Monitoring Interno/Externo', :description => "Tabla de Monitoreo Interno/Externo", :id_name => 'monitoring'
puts "Informacion Red Social Creada: " << social.name
social = InfoSocialNetwork.create! :name => 'Benchmark', :description => "Benchmark", :id_name => 'benchmark'
puts "Informacion Red Social Creada: " << social.name
