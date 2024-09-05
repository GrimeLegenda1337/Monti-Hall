class Door
  def initialize(id)
    raise ArgumentError, "Допустим только целочисленный тип данных" unless id.is_a?(Integer)
    @id = id
    @win_status = false
    @open_status = false
  end

  def set(parameter, value)
    if parameter == :id
      raise ArgumentError, "Запрет на изменение параметра id"
    end
    unless [true, false].include? value
      raise ArgumentError, "Значение параметра должно быть true/false"
    end
    case parameter
    when :win_status
      @win_status = value
    when :open_status
      @open_status = value
    else
      raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
  end

  def get(parameter)
    case parameter
    when :win_status
      @win_status
    when :open_status
      @open_status
    when :id
      @id
    else
      raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
  end

  private attr_accessor :win_status, :open_status, :id
end
# Дверь.В каждой игре их 3, id задаётся выше, при создании трёх дверей на "сцене".
# Кроме id, есть два нужных атрибута: выигрышная ли дверь и открыта ли она.
# Выигрышность задаётся лишь одной из двере при инициализации игры. Открытость меняется от действия ведущего
# Открытость храним для переформирования выборки дверей для ведущего и игрока на втором ходу
# Нижний класс, доступы через get/set. На возможные места поставлены ArgumentError
# сторонние функцию типо is_win_door и т.п. убраны, т.к. всего пару мест применения

