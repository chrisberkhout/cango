class AUDFATAdvice < ActiveRecord::Base
  enumerate :level, :with => AUDFATLevel
  belongs_to :country, :class_name => 'AUDFATCountry'
end
