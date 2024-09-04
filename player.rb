class Player
  def initialize
    @win_status = false
    @change_status = false
    @door_chosen = nil
  end
  def set(parameter, value)
    case parameter
    when :win_status, :change_status
      unless [true , false].include?(value)
        raise ArgumentError, "Значение параметра должно быть true/false"
      end
    when :door_chosen
      unless (1..3).include?(value)
        raise ArgumentError, "Значение door_chosen должно быть числом 1,2 или 3"
      end
    else
      raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
    instance_variable_set("@#{parameter}", value)
  end
  def get(parameter)
    case parameter
    when :win_status, :change_status , :door_chosen
      instance_variable_get("@#{parameter}")
    else
      raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
  end
  def is_winner
    @win_status
  end
  def changed_door
    @change_status
  end
  def chosen_door
    @door_chosen
  end
  private
  attr_accessor :win_status, :change_status, :door_chosen
end