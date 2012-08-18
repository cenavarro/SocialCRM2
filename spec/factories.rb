require 'factory_girl'

FactoryGirl.define do
  factory :user do |u|
  	u.id 1
    u.name 'foo'
	u.email 'prueba1@test.com'
	u.password 'prueba1'
	u.password_confirmation 'prueba1'
	u.rol_id 1
  end
end


