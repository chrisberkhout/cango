class Comment < ActiveRecord::Base
  has_and_belongs_to_many :iso_countries, :class_name => 'ISOCountry'
end
