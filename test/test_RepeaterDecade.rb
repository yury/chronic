require 'chronic'
require 'test/unit'

class TestRepeaterDecade < Test::Unit::TestCase

	def setup
		@now = Time.local(2006, 8, 16, 14, 0, 0, 0)
	end

	def test_discard_nonsense
		p = Chronic::RepeaterDecade::DECADE_PATTERN
		assert_no_match p, "1930"
		assert_no_match p, "1941s"
		assert_no_match p, "1829s"
	end

	def test_start_dates
		assert_decade_begins "1980s", 1980
		assert_decade_begins "20s", 1920
		assert_decade_begins "30's", 1930
		assert_decade_begins "2010's", 2010
		assert_decade_begins "'70s", 1970
	end

	def test_end_dates
		assert_decade_ends "1980s", 1990
		assert_decade_ends "20s", 1930
		assert_decade_ends "30's", 1940
		assert_decade_ends "2010's", 2020
		assert_decade_ends "'70s", 1980
	end

	private

	def assert_decade_begins(decade_str, year)
		d = Chronic::RepeaterDecade.new(decade_str)
		d.start = @now
		assert_equal Time.local(year, 1, 1), d.this.begin
	end

	def assert_decade_ends(decade_str, year)
		d = Chronic::RepeaterDecade.new(decade_str)
		d.start = @now
		assert_equal Time.local(year, 1, 1), d.this.end
	end
end
