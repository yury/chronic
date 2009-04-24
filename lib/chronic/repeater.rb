class Chronic::Repeater < Chronic::Tag #:nodoc:
  def self.scan(tokens, options)
    # for each token
    tokens.each_index do |i|
      if t = self.scan_for_season_names(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_month_names(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_day_names(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_day_portions(tokens[i]) then tokens[i].tag(t); next end
      if t = self.scan_for_times(tokens[i], options) then tokens[i].tag(t); next end
      if t = self.scan_for_units(tokens[i]) then tokens[i].tag(t); next end
    end
    tokens
  end
  
  def self.scan_for_season_names(token)
    scanner = {/^springs?$/i => :spring,
               /^summers?$/i => :summer,
               /^(autumn)|(fall)s?$/i => :autumn,
               /^winters?$/i => :winter}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterSeasonName.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    
    return nil
  end
  
  def self.scan_for_month_names(token)
    scanner = {/^jan\.?(uary)?$/i => :january,
               /^feb\.?(ruary)?$/i => :february,
               /^mar\.?(ch)?$/i => :march,
               /^apr\.?(il)?$/i => :april,
               /^may$/i => :may,
               /^jun\.?e?$/i => :june,
               /^jul\.?y?$/i => :july,
               /^aug\.?(ust)?$/i => :august,
               /^sep\.?(t\.?|tember)?$/i => :september,
               /^oct\.?(ober)?$/i => :october,
               /^nov\.?(ember)?$/i => :november,
               /^dec\.?(ember)?$/i => :december}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterMonthName.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    return nil
  end
  
  def self.scan_for_day_names(token)
    scanner = {/^m[ou]n(day)?$/i => :monday,
               /^t(ue|eu|oo|u|)s(day)?$/i => :tuesday,
               /^tue$/i => :tuesday,
               /^we(dnes|nds|nns)day$/i => :wednesday,
               /^wed$/i => :wednesday,
               /^th(urs|ers)day$/i => :thursday,
               /^thu$/i => :thursday,
               /^fr[iy](day)?$/i => :friday,
               /^sat(t?[ue]rday)?$/i => :saturday,
               /^su[nm](day)?$/i => :sunday}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterDayName.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    return nil
  end
  
  def self.scan_for_day_portions(token)
    scanner = {/^ams?$/i => :am,
               /^pms?$/i => :pm,
               /^mornings?$/i => :morning,
               /^afternoons?$/i => :afternoon,
               /^evenings?$/i => :evening,
               /^(night|nite)s?$/i => :night}
    scanner.keys.each do |scanner_item|
      return Chronic::RepeaterDayPortion.new(scanner[scanner_item]) if scanner_item =~ token.word
    end
    return nil
  end
  
  def self.scan_for_times(token, options)
    if token.word =~ /^\d{1,2}(:?\d{2})?([\.:]?\d{2})?$/
      return Chronic::RepeaterTime.new(token.word, options)
    end
    return nil
  end
  
  def self.scan_for_units(token)
    scanner = {/^years?$/i => :year,
               /^seasons?$/i => :season,
               /^months?$/i => :month,
               /^fortnights?$/i => :fortnight,
               /^weeks?$/i => :week,
               /^weekends?$/i => :weekend,
               /^(week|business)days?$/i => :weekday,
               /^days?$/i => :day,
               /^hours?$/i => :hour,
               /^minutes?$/i => :minute,
               /^seconds?$/i => :second,
      /^(лет|год|года)?$/i => :year,
      /^сезон(?:ов|a)?$/i => :season,
      /^месяц(?:ев)?$/i => :month,
      /^fortnights?$/i => :fortnight,
      /^недел(?:я|и|ь)?$/i => :week,
      /^выходн(?:ой|ых|ова)?$/i => :weekend,
      /^дн(?:я|ей)?$/i => :day,
      /^час(?:ов|а)?$/i => :hour,
      /^минут(?:ы|а)?$/i => :minute,
      /^секунд(?:ы|а)?$/i => :second
      }
    scanner.keys.each do |scanner_item|
      if scanner_item =~ token.word
        klass_name = 'Chronic::Repeater' + scanner[scanner_item].to_s.capitalize
        klass = eval(klass_name)
        return klass.new(scanner[scanner_item]) 
      end
    end
    return nil
  end
  
  def <=>(other)
    width <=> other.width
  end
  
  # returns the width (in seconds or months) of this repeatable.
  def width
    raise("Repeatable#width must be overridden in subclasses")
  end
  
  # returns the next occurance of this repeatable.
  def next(pointer)
    !@now.nil? || raise("Start point must be set before calling #next")
    [:future, :none, :past].include?(pointer) || raise("First argument 'pointer' must be one of :past or :future")
    #raise("Repeatable#next must be overridden in subclasses")
  end
  
  def this(pointer)
    !@now.nil? || raise("Start point must be set before calling #this")
    [:future, :past, :none].include?(pointer) || raise("First argument 'pointer' must be one of :past, :future, :none")
  end
  
  def to_s
    'repeater'
  end
end
