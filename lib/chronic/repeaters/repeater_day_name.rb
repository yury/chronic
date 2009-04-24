require 'date'
class Chronic::RepeaterDayName < Chronic::Repeater #:nodoc:
  DAY_SECONDS = 86400 # (24 * 60 * 60)
 
  def initialize(type)
    super
    @current_date = nil
  end

  def next(pointer)
    super
  
    direction = pointer == :future ? 1 : -1
  
    unless @current_date
      @current_date = DateTime.new(y=@now.year, m=@now.month, d=@now.day)
      @current_date += direction 
      day_num = symbol_to_number(@type)
    
      while @current_date.wday != day_num
        @current_date += direction
      end
    else
      @current_date += direction * 7 
    end
    next_date = @current_date.succ
    Chronic::Span.new(Chronic.time_class.local(@current_date.year, @current_date.month, @current_date.day),
                      Chronic.time_class.local(next_date.year, next_date.month, next_date.day))
  end
  
  
  def this(pointer = :future)
    super
    
    pointer = :future if pointer == :none
    self.next(pointer)
  end
  
  def width
    DAY_SECONDS
  end
  
  def to_s
    super << '-dayname-' << @type.to_s
  end
  
  private
  
  def symbol_to_number(sym)
    lookup = {:sunday => 0, :monday => 1, :tuesday => 2, :wednesday => 3, :thursday => 4, :friday => 5, :saturday => 6}
    lookup[sym] || raise("Invalid symbol specified")
  end
end
