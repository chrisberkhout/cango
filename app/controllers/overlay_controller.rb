class OverlayController < ApplicationController
  def data
    @countries = ISOCountry.where('borders_kml IS NOT NULL')
  end
end
