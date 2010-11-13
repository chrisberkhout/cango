namespace :iso do
  namespace :au do
    
    desc 'Load links between the ISO and AU country lists'
    task :load => :environment do
      filename = 'db/data/iso_au.txt'
      puts "Loading links between the ISO and AU country lists from '#{filename}'..."
      open(filename).readlines.each do |l|
        next if l[/^\#/].present? || l.blank?
        iso_official_short_name, au_name = l.chomp.split(';')
        iso_country = ISOCountry.where(:official_short_name => iso_official_short_name).first || 
          raise("Could not find the ISO country: '#{iso_official_short_name}'!")
        au_country  = AUCountry.where(:name => au_name).first || 
          raise("Could not find the AU country: '#{au_name}'!")
        if au_country.not_in?(iso_country.au_countries) then
          iso_country.au_countries << au_country
          iso_country.save!
          puts "NEW LINK LOADED :  #{iso_official_short_name}  <->  #{au_name}"
        else
          puts "old link exists :  #{iso_official_short_name}  <->  #{au_name}"
        end
      end
    end

    desc 'Report on the links between the ISO and AU country lists'
    task :report => :environment do
      puts "\nISO COUNTRIES NOT LINKED TO ANY AU COUNTRY:"
      ISOCountry.all.each { |c| puts "    #{c.official_short_name}" if c.au_countries.count == 0 }
      puts "\nAU COUNTRIES NOT LINKED TO ANY ISO COUNTRY:"
      AUCountry.all.each { |c| puts "    #{c.name}" if c.iso_countries.count == 0 }
      puts "\nISO COUNTRIES LINKED TO SEVERAL AU COUNTRIES:"
      ISOCountry.all.each { |c| puts "    #{c.official_short_name}: #{c.au_countries.map{|i| "'#{i.name}'" }.join(', ')}" if c.au_countries.count > 1 }
      puts "\nAU COUNTRIES LINKED TO SEVERAL ISO COUNTRIES:"
      AUCountry.all.each { |c| puts "    #{c.name}: #{c.iso_countries.map{|i| "'#{i.official_short_name}'" }.join(', ')}" if c.iso_countries.count > 1 }
    end
    
  end
end
