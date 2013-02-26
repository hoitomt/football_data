$LOAD_PATH << File.expand_path( File.dirname(__FILE__) + '/../lib' )
require 'test/unit'
require 'football_data'
require 'football_data/raw_game'
require 'football_data/scrape'

class TestHelper < Test::Unit::TestCase
  def setup
    path = File.expand_path(File.dirname(__FILE__) + "/../lib/config/config.yml")
    config_file = YAML::load(File.open(path))
    FootballData.configure do |config|
      config.db_path = config_file["test_db_path"]
    end
  end
end