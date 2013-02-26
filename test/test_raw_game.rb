require_relative 'test_helper'

class TestStuff < TestHelper
  def setup
    super
    @count = FootballData::RawGame.count
  end

  def testRawGameFromCovers
    FootballData::RawGame.destroy
    scrape_count = FootballData::Scrape.get_team_year(1, '1999-2000')
    assert_equal FootballData::RawGame.all.count, scrape_count
  end

  # It should only create unique records
  def test_idempotency_validation
    FootballData::Scrape.get_team_year(1, '1999-2000')
    assert_equal FootballData::RawGame.count, @count
  end
end