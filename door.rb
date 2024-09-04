class Door
  def initialize
    @win_st = false
    @open_st = false
  end
  def set(parameter ,value)
    unless [true, false].include? value
      raise ArgumentError, "Значение параметра должно быть true/false"
    end
    case parameter
    when :win_st
      @win_st = value
    when :open_st
      @open_st = value
    else  raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
  end
  def get(parameter)
    case parameter
    when :win_st
      @win_st
    when :open_st
      @open_st
    else raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
  end
  private attr_accessor :win_st, :open_st
end