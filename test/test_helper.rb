$LOAD_PATH << File.expand_path( File.dirname(__FILE__) + '/../lib' )
require 'test/unit'
require 'football_data'
require 'football_data/raw_game'
require 'football_data/scrape'

class TestHelper < Test::Unit::TestCase
  def setup
    FootballData.configure do |config|
      config.db_path = "postgres://hoitomt:badger@localhost/football_data_test"
    end
  end
end