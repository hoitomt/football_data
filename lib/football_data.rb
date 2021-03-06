require "football_data/version"
require "football_data/config"
require "football_data/raw_game"
require "football_data/game"
require "football_data/team"
require "football_data/scrape"
require 'dm-core'
require 'dm-migrations'

module FootballData

  class << self
    attr_accessor :db_path

    def configure
      yield self if block_given?
      DataMapper.setup(:default, self.db_path)
    end

    def get_data
      FootballData::Scrape.scrape_nfl
    end
  end
end
