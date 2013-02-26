require 'data_mapper'

module FootballData
  class Game
    include DataMapper::Resource
    # Game.raise_on_save_failure = true

    property :id, Serial
    property :week, String
    property :game_date, Date
    property :home_team_id, Integer
    property :visiting_team_id, Integer
    property :home_team_score, Integer
    property :visiting_team_score, Integer
    property :home_spread, Float
    property :over_under, Float
    property :over_under_result, String

    validates_presence_of :home_team_id
    validates_uniqueness_of :home_team_id, :scope => :game_date
    validates_with_method :no_matching_game

    def no_matching_game
      g = Game.all(:game_date => self.game_date) & Game.all(:visiting_team_id => self.home_team_id)
      if g.blank?
        return true
      else
        [false, "This game exists where the home team is the visitor"]
      end
    end

    def game_date=g_date
      if g_date.is_a?(Date)
        super g_date
      else
        date_parts = g_date.split('/').collect{|x| x.to_i}
        super Date.new(date_parts[2], date_parts[0], date_parts[1])
      end
    end

    def home_team_covered?
      if home_spread < 0
        return home_team_score - visiting_team_score > home_spread.abs
      else
        return visiting_team_score - home_team_score > home_spread
      end
    end

    def home_team_result
      return "Tie" if home_team_score - visiting_team_score == 0
      home_team_score - visiting_team_score > 0 ? "Win" : "Loss"
    end

    def error_messages
      [].tap do |a|
        errors.each do |e|
          a << e
        end
      end
    end

    def self.params_from_raw_game(raw_game)
      {}.tap do |h|
        h.merge!(set_teams_score(raw_game))
        h[:game_date] = raw_game.game_date
        h[:week] = raw_game.week
        h[:over_under] = raw_game.o_u
        h[:over_under_result] = raw_game.o_u_result
      end
    end

    def self.set_teams_score(raw_game)
      {}.tap do |h|
        score = raw_game.score.split('-')
        if raw_game.location == "away"
          h[:home_team_id] = Team.find(raw_game.opponent).id
          h[:visiting_team_id] = Team.find(raw_game.team_name).id
          h[:home_team_score] = score[1]
          h[:visiting_team_score] = score[0]
          h[:home_spread] = -1 * (raw_game.spread || 0)
        else
          h[:home_team_id] = Team.find(raw_game.team_name).id
          h[:visiting_team_id] = Team.find(raw_game.opponent).id
          h[:home_team_score] = score[0]
          h[:visiting_team_score] = score[1]
          h[:home_spread] = raw_game.spread
        end
      end
    end

  end
  DataMapper.finalize
end

