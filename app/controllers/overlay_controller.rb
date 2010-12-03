class OverlayController < ApplicationController
  def data
    @countries = ISOCountry.where('borders_kml IS NOT NULL').includes(:au_countries)
  end
end
