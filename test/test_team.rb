require_relative 'test_helper'

class TestTeam < TestHelper
  def test_seed
    FootballData::Team.seed
    assert_equal(FootballData::Team.all.count, 32)
  end

  def test_find_by_alias
    search = 'N.Y. Giants'
    team = FootballData::Team.find(search)
    assert_not_nil team
    assert_equal(team.name, 'New York Giants')
  end

  def test_no_find
    search = 'NY Giants'
    team = FootballData::Team.find(search)
    assert_nil team
  end
end