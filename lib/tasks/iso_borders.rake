namespace :iso do
  namespace :borders do
    
    def borders_kml(borders_json)
      '<MultiGeometry>' +
      ActiveSupport::JSON.decode(borders_json).map do |poly|
        '<Polygon><outerBoundaryIs><LinearRing><coordinates>' +
        poly.map { |point| point.join(',') + ',0' }.join(' ') +
        '</coordinates></LinearRing></outerBoundaryIs></Polygon>'
      end.join('') +
      '</MultiGeometry>'
    end
    
    desc 'Load border data for the ISO countries'
    task :load => :environment do
      filename = 'db/data/iso_borders_protovis.txt'
      puts "Loading border data for ISO countries from '#{filename}'..."
      open(filename).readlines.each do |l|
        next if l[/^\#/].present? || l.blank?
        iso_official_short_name, borders_json = l.chomp.split(';')
        iso_country = ISOCountry.where(:official_short_name => iso_official_short_name).first || 
          raise("Could not find the ISO country: '#{iso_official_short_name}'!")
        iso_country.borders_kml = borders_kml(borders_json)
        iso_country.save!
        puts "Loaded border data for:  #{iso_official_short_name}"
      end
    end

    desc 'Report on the border data for ISO countries'
    task :report => :environment do
      puts "\nISO COUNTRIES WITHOUT BORDER DATA:"
      ISOCountry.all.each { |c| puts "    #{c.official_short_name}" if c.borders_kml.blank? }
    end
    
  end
end
