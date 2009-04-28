class Chronic::RepeaterDecade < Chronic::Repeater #:nodoc:
  DECADE_PATTERN = /^(?:(\d{2})|'|)(\d0)'?s$/
  
  def initialize(decade)
    super
    
    m = decade.match DECADE_PATTERN
    @decade_start = Time.construct(((m[1] || '19') + m[2]).to_i, 1, 1)
  end
  
  def this(context = :past)
    super
    Chronic::Span.new(@decade_start, @decade_start + width)
  end
  
  def width
    Time.construct(@decade_start.year + 10, 1, 1) - @decade_start
  end
  
  def to_s
    super << '-year'
  end
end