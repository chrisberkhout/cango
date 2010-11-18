class ISOCountry < ActiveRecord::Base
  has_and_belongs_to_many :au_countries, :class_name => 'AUCountry'
  has_and_belongs_to_many :comments
end
