require 'data_mapper'

module FootballData
  class Team
    include DataMapper::Resource
    property :id, Serial
    property :name, String, :unique => true
    property :alias, String

    def self.find(search_string)
      Team.first(:conditions => ['name = ? OR alias = ?', search_string, search_string])
    end

    def self.seed
      Team.create(:name => "Cleveland Browns", :alias => "Cleveland")
      Team.create(:name => "Buffalo Bills", :alias => "Buffalo")
      Team.create(:name => "Seattle Seahawks", :alias => "Seattle")
      Team.create(:name => "Miami Dolphins", :alias => "Miami")
      Team.create(:name => "Arizona Cardinals", :alias => "Arizona")
      Team.create(:name => "Atlanta Falcons", :alias => "Atlanta")
      Team.create(:name => "Kansas City Chiefs", :alias => "Kansas City")
      Team.create(:name => "New Orleans Saints", :alias => "New Orleans")
      Team.create(:name => "Philadelphia Eagles", :alias => "Philadelphia")
      Team.create(:name => "New York Giants", :alias => "N.Y. Giants")
      Team.create(:name => "Denver Broncos", :alias => "Denver")
      Team.create(:name => "Dallas Cowboys", :alias => "Dallas")
      Team.create(:name => "San Diego Chargers", :alias => "San Diego")
      Team.create(:name => "Green Bay Packers", :alias => "Green Bay")
      Team.create(:name => "Baltimore Ravens", :alias => "Baltimore")
      Team.create(:name => "San Francisco 49ers", :alias => "San Francisco")
      Team.create(:name => "Minnesota Vikings", :alias => "Minnesota")
      Team.create(:name => "Pittsburgh Steelers", :alias => "Pittsburgh")
      Team.create(:name => "St Louis Rams", :alias => "St. Louis")
      Team.create(:name => "Chicago Bears", :alias => "Chicago")
      Team.create(:name => "Carolina Panthers", :alias => "Carolina")
      Team.create(:name => "Houston Texans", :alias => "Houston")
      Team.create(:name => "Tennessee Titans", :alias => "Tennessee")
      Team.create(:name => "New England Patriots", :alias => "New England")
      Team.create(:name => "Tampa Bay Buccaneers", :alias => "Tampa Bay")
      Team.create(:name => "Cincinnati Bengals", :alias => "Cincinnati")
      Team.create(:name => "New York Jets", :alias => "N.Y. Jets")
      Team.create(:name => "Detroit Lions", :alias => "Detroit")
      Team.create(:name => "Indianapolis Colts", :alias => "Indianapolis")
      Team.create(:name => "Washington Redskins", :alias => "Washington")
      Team.create(:name => "Oakland Raiders", :alias => "Oakland")
      Team.create(:name => "Jacksonville Jaguars", :alias => "Jacksonville")
    end

  end
  DataMapper.finalize
end









