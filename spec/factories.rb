require 'factory_girl'

FactoryGirl.define do
  factory :user do |u|
  	u.id 1
    u.name 'foo'
	u.email 'user@test.com'
	u.password 'please'
	u.password_confirmation 'please'
	u.rol_id 1
  end
end


