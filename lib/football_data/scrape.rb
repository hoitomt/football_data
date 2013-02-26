require 'open-uri'
require 'nokogiri'

module FootballData
  class Scrape
    class << self

      @@years = FootballData::Config.nfl_years
      @@url = FootballData::Config.nfl_spreads_url
      @@teams = (1..32)

      def get_data_from_covers
        result = []
        count = 0
        @@years.each do |year|
          @@teams.each do |team|
            p "#{@@url}/#{year}/team#{team}.html"
            count += get_team_year(team, year)
          end
        end
      end

      def get_team_year(team, year)
        count = 0
        url = "#{@@url}/#{year}/team#{team}.html"
        open(url) do |f|
          return if f.base_uri =~ (/error/)
          p = ""
          f.each do |line|
            p += line.chomp!
          end
          doc = Nokogiri::HTML(p)
          x = doc.css('table.data tr')
          x.each do |row|
            raw_game = parse_row(row)
            next if raw_game.nil?
            raw_game.team_name = team_name(doc)
            if raw_game.save
              count += 1
            end
          end
        end
        count
      end

      def team_name(doc)
        return '' if doc.css('div.teamname > h1.teams').nil?
        raw_team = doc.css('div.teamname > h1.teams').first.content
        return '' if raw_team.nil?
        team = raw_team.gsub(/[^a-zA-Z0-9]/, ' ').strip.squeeze(' ')
      end

      def parse_row(n_row)
        a = nodeset_to_array(n_row)
        return nil if a.empty?
        RawGame.new.tap do |g|
          day_date = a[0].split(' ')
          g.day = day_date.first
          g.game_date = day_date.last
          g.location = a[1].index('@') ? 'away' : 'home'
          g.opponent = a[1].gsub('@', '').strip
          result, score = a[2].split(' ')
          g.result = result
          g.score = score
          g.week = a[3]
          spread_result, spread = a[4].split(' ')
          g.spread = spread
          g.spread_result = spread_result
          o_u_result, o_u = a[5].split(' ')
          g.o_u_result = o_u_result
          g.o_u = o_u
        end
      end

      def nodeset_to_array(nodeset)
        [].tap do |a|
          # p "NodeSet #{nodeset}"
          nodeset.css('td.datacell').each do |field|
            a << field.content.strip.squeeze(' ')
          end
        end
      end

    end
  end
end