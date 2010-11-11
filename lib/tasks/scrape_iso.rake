require 'open-uri'
require 'iconv'

namespace :scrape do
  desc 'Load the ISO3166 country list or check it for changes'
  task :iso => :environment do
    
    scrape = ISOScrape.create!(:started_at => Time.now, :successful => false)
    ISOScrape.transaction do
      url = 'http://www.iso.org/iso/list-en1-semic-3.txt'
      lines = open(url).readlines.map{ |l| Iconv.conv("UTF-8","ISO-8859-1",l).chomp }[1..-1].reject{ |l| l.blank? }

      if ISOCountry.count == 0
        lines.each do |l|
          official_short_name, code = l.split(';')
          small_words = ['OF', 'AND', 'THE', 'DA', 'D', 'S']
          name = official_short_name.split(/\b/).map{ |w| w.is_in?(small_words) ? w.downcase : w.capitalize }.join()
          name.sub!(/^./)       { |m| m.upcase }
          name.sub!(/\, \w/)    { |m| m.upcase }   # "Macedonia, The Former Yugoslav Republic of"
          name.sub!(/Mcdonald/) { |m| 'McDonald' } # Heard Island and McDonald Islands
          name.sub!(/U\.s\./i)  { |m| 'U.S.' }     # "Virgin Islands, U.S."
          name.gsub!(/Ô/)       { |m| 'ô' }        # Côte d'Ivoire
          name.gsub!(/É/)       { |m| 'é' }        # Réunion, Saint Barthélemy
          ISOCountry.create!({
            :official_short_name => official_short_name,
            :name => name,
            :code => code,
          })
        end
        puts "#{lines.count} Countries have been loaded from the ISO3166 list."
      else
        existing_lines = ISOCountry.all.map{ |c| "#{c.official_short_name};#{c.code}" }
        removed_lines = existing_lines.select{ |l| l.not_in?(lines) }
        added_lines   = lines.select{ |l| l.not_in?(existing_lines) }
        if removed_lines.count + added_lines.count == 0 then
          puts "There have been no changes to the ISO3166 list of #{ISOCountry.count} countries."
        else
          puts "These countries in the database have been removed from ISO3166:\n#{removed_lines.join("\n")}" if removed_lines.present?
          puts "These countries from ISO3166 have not been loaded into the database:\n#{added_lines.join("\n")}" if added_lines.present?
        end
      end
    
      scrape.update_attributes!(:ended_at => Time.now, :successful => true)
    end

  end
end
