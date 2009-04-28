require 'chronic'
require 'test/unit'

class TestRepeaterSeason < Test::Unit::TestCase

  def setup
    # Wed Aug 16 14:00:00 2006
    @now = Time.local(2006, 8, 16, 14, 0, 0, 0)
    @season = Chronic::RepeaterSeason.new(:@season)
    @season.start = @now
  end

  def test_next_future
    next_season = @season.next(:future)
    assert_equal Time.local(2006, 9, 23).to_minidate, next_season.begin.to_minidate
    assert_equal Time.local(2006, 12, 21).to_minidate, next_season.end.to_minidate
  end

  def test_next_past
    next_season = @season.next(:past)
    assert_equal Time.local(2006, 3, 20).to_minidate, next_season.begin.to_minidate
    assert_equal Time.local(2006, 6, 20).to_minidate, next_season.end.to_minidate
  end

  def test_this_future
    next_season = @season.this(:future)
    assert_equal Time.local(2006, 8, 17).to_minidate, next_season.begin.to_minidate
    assert_equal Time.local(2006, 9, 22).to_minidate, next_season.end.to_minidate
  end

  def test_this_past
    next_season = @season.this(:past)
    assert_equal Time.local(2006, 6, 21).to_minidate, next_season.begin.to_minidate
    assert_equal Time.local(2006, 8, 16).to_minidate, next_season.end.to_minidate
  end

  def test_this_none
    next_season = @season.this(:future)
    assert_equal Time.local(2006, 8, 17).to_minidate, next_season.begin.to_minidate
    assert_equal Time.local(2006, 9, 22).to_minidate, next_season.end.to_minidate
  end

end