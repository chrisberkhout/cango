class AUDFATLevel < ActiveEnum::Base
  value :id => 1, :name => 'Be alert to own security'
  value :id => 2, :name => 'Exercise caution'
  value :id => 3, :name => 'High degree of caution'
  value :id => 4, :name => 'Reconsider your need to travel'
  value :id => 5, :name => 'Do not travel'
end
