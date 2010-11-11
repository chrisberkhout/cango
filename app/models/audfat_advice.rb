class AUAdvice < ActiveRecord::Base
  enumerate :level, :with => AULevel
  belongs_to :country, :class_name => 'AUCountry'
end
