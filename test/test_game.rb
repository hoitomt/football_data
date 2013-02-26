require_relative 'test_helper'
require 'Date'

class TestGame < TestHelper
  def setup
    super
    FootballData::Game.destroy
    FootballData::RawGame.destroy
    raw_game_hash = {
      :team_name => 'Detroit Lions',
      :day => 'Sunday',
      :game_date => "1/2/11",
      :opponent => 'Minnesota',
      :result => 'W',
      :score => '20-13',
      :week => 'Week 17',
      :spread_result => 'W',
      :spread => -3.5,
      :o_u_result => 'U',
      :o_u => 43.5,
      :location => 'home'
    }
    @raw_game = FootballData::RawGame.create(raw_game_hash)
  end

  def test_new
    @params = FootballData::Game.params_from_raw_game(@raw_game)
    r = FootballData::Game.new(@params)
    assert(r.valid?, "Invalid #{r.error_messages}")
  end

  def test_persist
    @params = FootballData::Game.params_from_raw_game(@raw_game)
    r = FootballData::Game.new
    r.attributes = @params
    r.save
    g = FootballData::Game.all
    assert_equal(g.count, 1)
  end

  def test_home_attributes
    @params = FootballData::Game.params_from_raw_game(@raw_game)
    r = FootballData::Game.create(@params)
    g = FootballData::Game.all.last
    home_team = FootballData::Team.find(@raw_game.team_name)
    visiting_team = FootballData::Team.find(@raw_game.opponent)
    assert_equal(g.week, @raw_game.week)
    assert_equal(g.game_date, @raw_game.game_date)
    assert_equal(g.home_team_id, home_team.id)
    assert_equal(g.visiting_team_id, visiting_team.id)
    assert_equal(g.home_team_score, 20)
    assert_equal(g.visiting_team_score, 13)
    assert_equal(g.home_spread, -3.5)
    assert_equal(g.over_under, 43.5)
    assert_equal(g.over_under_result, "U")
  end

  def test_visitor_attributes
    @raw_game.location = 'away'
    @params = FootballData::Game.params_from_raw_game(@raw_game)
    r = FootballData::Game.create(@params)
    g = FootballData::Game.all.last
    home_team = FootballData::Team.find(@raw_game.opponent)
    visiting_team = FootballData::Team.find(@raw_game.team_name)
    assert_equal(g.week, @raw_game.week)
    assert_equal(g.game_date, @raw_game.game_date)
    assert_equal(g.home_team_id, home_team.id)
    assert_equal(g.visiting_team_id, visiting_team.id)
    assert_equal(g.home_team_score, 13)
    assert_equal(g.visiting_team_score, 20)
    assert_equal(g.home_spread, 3.5)
    assert_equal(g.over_under, 43.5)
    assert_equal(g.over_under_result, "U")
  end

  def test_one_game_for_home_visitor
    @params_h = FootballData::Game.params_from_raw_game(@raw_game)
    @raw_game.opponent = 'Minnesota'
    @raw_game.team_name = 'Detroit Lions'
    @raw_game.score = '13-20'
    @raw_game.spread = 3.5
    @raw_game.spread_result = 'L'
    @raw_game.location = 'away'
    @params_v = FootballData::Game.params_from_raw_game(@raw_game)
    home = FootballData::Game.create(@params_h)
    visitor = FootballData::Game.create(@params_v)
    total = FootballData::Game.all
    assert_equal(total.count, 1)
  end

end