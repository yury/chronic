# date range support and parsing of strings calling for a sequence of dates 
# (currently only 'nth Tuesday in June [2009]' etc).
#
# My first take -- not stable; a lot of fat to cut out.
#
# Chronic::Blunt.dates(Date.today..Date.today+100, {:day => "Wednesday", :week => 0})
# Chronic::Blunt.range(dates_array,{:csv => ','})
# Chronic::Blunt.parse("second Saturday in April 2010")
#
# Blunt b/c it's err, a blunt instrument :)
#
# ...with the exception of brainopia's Array method (which he very 
# kindly wrote while I was troubleshooting a more verbose version
# on #ruby-lang). (github.com/brainopia)
#

  require 'rubygems'
  require 'activesupport'

  class Object
    def tap
      yield self; self
    end
  end

  class Array #all credit to brainopia for this wonderful method
    def group_by_range
      uniq.sort.inject([[first]]) do |result, it|
        result << [] unless result.last.last.next == it
        result.tap {|ar| ar.last << it }
      end
    end
  end


  class Chronic::Blunt

    ORDINALS = %w[first second third fourth fifth]
    
    attr_accessor :result

    def initialize
      @result = []
    end
    
    def self.dates(passed_range, specified_options={})
      default_options = {:day => false,
                         :week => :every,
                         :hour => false}
      options = default_options.merge specified_options
      specified_options.keys.each do |key|
        default_options.keys.include?(key) || raise(Chronic::InvalidArgumentException, "#{key} is not a valid option key.")
      end
      
      if passed_range.class == Array
        ranges = passed_range
      else
        ranges = [passed_range]
      end

      @result = []

      ranges.each do |range|
       first = get_date(range.first)-1
       last = get_date(range.last)
       @result << (first += 1) while first < last
      end
      if options[:day]
        find_dates(@result,options[:day],options[:hour],options[:week])
        @result
      end
      @result
    end

    def self.parse(string)
      if (string =~ /first|second|third|fourth|last/) == 0
        query = string.gsub(/in/){}.downcase.split(/\s+/)
     
        if query[0] == 'last'
          week = -1
        else
          week = ORDINALS.index(query.first)
        end
        day = query[1].titleize
        month = Date.parse("#{query[3]}/#{query[2]}")
        @result = self.dates(month..month.end_of_month, {:day => day, :week => week})
      else  
        date = Chronic.parse(string)
      end
      @result
    end
 
    def self.range(dates, specified_options={})
      default_options = {:csv => false}
      options = default_options.merge specified_options
      
      specified_options.keys.each do |key|
        default_options.keys.include?(key) || raise(Chronic::InvalidArgumentException, "#{key} is not a valid option key.")
      end

      ranges = dates.flatten.map! {|date| get_date(date) }.group_by_range.map! {|it| it.first..it.last}
      if options[:csv]
        if options[:csv] == true
          @result = to_csv(ranges,'|')
        else
          @result = to_csv(ranges,options[:csv].to_s)
        end
      else
        @result = ranges
      end
    end 
  
    private

    def self.to_csv(ranges,delimiter)
      d = delimiter
      csv = []
      ranges.each {|range| csv << "#{range.first}#{d}#{range.last}"}
      csv
    end
 
    def self.find_dates(dates,query,hour,week)
      day = Date::DAYNAMES.rindex(query)
        results = []
        dates.each{|d| 
          if hour
            results << (d.to_time + hour.hours) if d.wday == day
          else
            results << d if d.wday == day
          end
        }
        if week != :every
          months = []
          results.each {|day| months << Date.parse("#{day.year}/#{day.mon}")}
          months.uniq!
          months.sort!
          month_days = []
          months.each do |month|
            days = []
            results.each {|day| days << day if day.mon == month.mon}
            if hour
              month_days << days.slice(week).to_time + hour.hours
            else
              month_days << days.slice(week)
            end
          end
          @result = month_days
        else
          @result = results
        end
      end

      def self.get_date(it)
        case it.class.to_s
        when "Date"
          date = it 
        when "Time" 
          date = Date.parse(it.strftime("%Y/%m/%d"))
        else
          date = Date.parse(Chronic.parse(it).strftime("%Y/%m/%d"))
        end
      end
    end
