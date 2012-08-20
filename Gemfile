source 'http://rubygems.org'

gem 'rails', "= 3.1.8"
 
# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem "therubyracer", :require => 'v8'
gem 'mysql2', "= 0.3.11"
#gem 'pg'

gem 'slim', "= 1.2.2"
gem 'rake', ">= 0.9.2.2"
gem 'heroku', "= 2.30.2"
gem "escape_utils", "= 0.2.4"
gem 'simplecov', :require => false, :group => :test

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier', "= 1.2.4"
end

gem 'jquery-rails', "= 1.0.19"

gem "rspec-rails", "= 2.11.0", :group => [:development, :test]
gem "factory_girl_rails", "= 4.0.0", :group => :test
gem "capybara", ">= 1.0.1", :group => :test
gem "database_cleaner", ">= 0.6.7", :group => :test
#gem "launchy", ">= 2.0.5", :group => :test
gem "devise", ">= 1.4.4"
gem "slim-rails", "= 1.0.3"

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

group :development do
  gem 'pg'
  gem 'guard', "= 1.3.0"
  #gem 'rb-fsevent'
  #gem 'growl_notify'
  gem 'guard-livereload', "= 1.0.0"
  #gem 'ruby-debug19', :require => 'ruby-debug'
end

group :test do
  # Pretty printed test output
  gem 'minitest', "= 3.3.0"
  gem 'turn', "= 0.9.6", :require => false
  gem "cucumber-rails", "= 1.3.0"
end
