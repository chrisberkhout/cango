class AUCountry < ActiveRecord::Base

  has_many   :advices,     :class_name => 'AUAdvice', :foreign_key => :country_id
  belongs_to :last_scrape, :class_name => 'AUScrape', :foreign_key => :last_scrape_id

  def last_advices
    AUAdvice.where(:country_id => id, :issued_on => last_issued_on)
  end
  
  def last_overall_advice
    last_advices.where(:overall => true).first
  end

  def last_other_advices
    last_advices.where(:overall => false)
  end

end
