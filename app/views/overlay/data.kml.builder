cache "kml/#{Date.current.strftime('%Y-%m-%d')}" do
  xml.kml(:xmlns => 'http://earth.google.com/kml/2.2') do
    xml.Document do
  
      xml.name('DFAT Travel Advisories')
      xml.description { xml.cdata!('description of the overall KML document') }
      [ 
        {:id => 'style_0', :line_color => '80c0c0c0', :poly_color => '4dc0c0c0'},
        {:id => 'style_1', :line_color => 'cc000000', :poly_color => 'bf00ff00'},
        {:id => 'style_2', :line_color => 'cc000000', :poly_color => 'bf007e00'},
        {:id => 'style_3', :line_color => 'cc000000', :poly_color => 'bf336699'},
        {:id => 'style_4', :line_color => 'cc000000', :poly_color => 'bf0080ff'},
        {:id => 'style_5', :line_color => 'cc000000', :poly_color => 'bf0000ff'} 
      ].each do |style|
        xml.Style(:id => style[:id]) do
          xml.BalloonStyle { xml.text { xml.cdata!( render(:partial => 'balloon_style.html') ) } }
          xml.ListStyle
          xml.LineStyle do
            xml.color(style[:line_color])
            xml.width('1')
          end
          xml.PolyStyle do
            xml.color(style[:poly_color])
          end
        end
      end
  
      xml.Folder do
        xml.name('DFAT Travel Advisories')
  
        @countries.each do |country|
          xml.Placemark do
            xml.name(country.name)
            xml.description { xml.cdata!(render(:partial => "country_description.html", :object => country, :as => :country)) }
            xml.styleUrl('#style_' + country.au_countries.map{ |c| c.last_overall_advice && c.last_overall_advice.level }.max.to_s)
            xml << country.borders_kml+"\n"
          end
        end
    
      end
  
    end
  end
end