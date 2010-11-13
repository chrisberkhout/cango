xml.kml(:xmlns => 'http://earth.google.com/kml/2.2')

xml.Document do
  
  xml.name('DFAT Travel Advisories')
  xml.description { xml.cdata!('description of the overall KML document') }
  # style defs come in here
  
  xml.Folder do
    xml.name('DFAT Travel Advisories')
  
    @countries.each do |country|
      xml.Placemark do
        xml.name(country.name)
        xml.description { xml.cdata!(render(:partial => "country_description", :locals => { :country => country })) }
        xml.styleUrl('#someStyleDef')
        xml << country.borders_kml+"\n"
      end
    end
    
  end
  
end
