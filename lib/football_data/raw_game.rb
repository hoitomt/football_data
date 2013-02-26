require 'data_mapper'

module FootballData

  class RawGame
    include DataMapper::Resource
    property :id, Serial
    property :team_name, String
    property :day, String
    property :game_date, Date
    property :opponent, String
    property :result, String
    property :score, String
    property :week, String
    property :spread_result, String
    property :spread, Float
    property :o_u_result, String
    property :o_u, Float
    property :location, String

    validates_uniqueness_of :team_name, :scope => :game_date

    def game_date=g_date
      date_parts = g_date.split('/').collect{|x| x.to_i}
      year = date_parts[2]
      if (0..80) === year
        year += 2000
      elsif (80...100) === year
        year += 1900
      end
      super Date.new(year, date_parts[0], date_parts[1])
    end

    def away_game
      @location == "away"
    end

  end
  DataMapper.finalize
end
