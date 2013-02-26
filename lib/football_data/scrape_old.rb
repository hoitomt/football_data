require 'open-uri'
require 'date'

module FootballData
  class ScrapeOld
    class << self
      def scrape_nfl
        years = FootballData::Config.nfl_years
        url = FootballData::Config.nfl_spreads_url
        File.open("results_NFL_#{DateTime.now.strftime("%m_%d_%Y_%H_%M")}.csv", 'w') do |d|
          d.print("team_name,day,date,opponent,result,score,week,spread_result,spread,o_u_result,o_u,location\n")
          years.each do |yx|
            1.upto(3) do |i| #32
              puts "#{yx}, team number #{i}"
              open("#{url}/#{yx}/team#{i}.html") do |f|
                x = nil
                y = 0
                z = nil
                a = nil
                team_name_row = 0
                team_name = ""
                game_tr = []
                b = nil
                road = false

                f.each do |line|
                  game_tr = line.scan(/<tr>/) if game_tr[0].nil?
                  x = line.scan(/<td class="datacell">/)
                  if !game_tr[0].nil? && !x[0].nil?
                    y = 1
                    d.write "#{team_name},"
                    game_tr = []
                  end
                  y = 1 unless x[0].nil? #this row has game data
                  z = line.scan(/<\/tr>/)
                  if !z[0].nil? && y == 1 #end of row with game data
                    if road
                      d.write "road"
                    else
                      d.write "home"
                    end
                    road = false
                    y = 0
                    d.write "\n"
                  end

                  a = line.scan(/<h1 class="teams">/)
                  team_name_row = 1 unless a[0].nil?
                  b = line.scan(/<\/h1>/)
                  team_name_row = 0 unless b[0].nil?

                  if team_name_row == 1
                    line = line.gsub(/<[a-zA-Z\s\-=:\/."\d?]*(>|\s)/, '').strip
                    team_name = team_name + " #{line}" #if team_name.nil? || team_name.empty?
                  end

                  if y == 1
                    road = true unless line.scan(/@/)[0].nil?
                    line = line.gsub(/@/, '').strip #@ will help identify the road games if desired
                    line = line.gsub(/<[a-zA-Z\s\-=:\/."\d?]*(>|\s)/, '').strip
                    d.write "#{line}," if line.length > 0
                  end
                end
              end
            end
          end
        end

      end
    end
  end
end
