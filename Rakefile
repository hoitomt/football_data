$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + '../lib')
require "bundler/gem_tasks"
require 'rake/testtask'
require 'football_data'

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

"Add tenv=true to set up test environment"
namespace :db do

  task :configure do
    if ENV['tenv']
      p "Updating Test Database"
      FootballData.configure do |config|
        config.db_path = "postgres://hoitomt:badger@localhost/football_data_test"
      end
    else
      p "Updating Database"
      FootballData.configure do |config|
        config.db_path = "postgres://hoitomt:badger@localhost/football_data"
      end
    end
  end

  task :migrate => :configure do
    FootballData::RawGame.auto_migrate!
    FootballData::Game.auto_migrate!
    FootballData::Team.auto_migrate!
  end

  desc "Update the database tables"
  task :update => :configure do
    FootballData::RawGame.auto_upgrade!
    FootballData::Game.auto_upgrade!
    FootballData::Team.auto_upgrade!
  end

  task :clear => :configure do
    FootballData::RawGame.destroy
    FootballData::Game.destroy
    FootballData::Team.destroy
  end

  desc "Seed the test database"
  task :seed => :configure do
    FootballData::Team.seed
  end

  desc "Set up the test database. Add tenv=true to setup test db"
  task :setup => [:migrate, :seed] do
  end

end

namespace :games do

  desc "Configure the database"
  task :configure do
    FootballData.configure do |config|
      config.db_path = "postgres://hoitomt:badger@localhost/football_data"
    end
  end

  desc "Get Raw Data"
  task :raw_data => :configure do
    FootballData::Scrape.get_data_from_covers
  end

  desc "Populate the game table from the raw data table"
  task :create => :configure do
    raw_games = FootballData::RawGame.all
    raw_games.each do |rg|
      p "team name #{rg.team_name}"
      game_params = FootballData::Game.params_from_raw_game(rg)
      FootballData::Game.create(game_params)
    end
  end

end