class Player
  def initialize
    @win_status = false
    @change_status = false
    @door_chosen = nil
  end

  def set(parameter, value)
    case parameter
    when :win_status, :change_status
      unless [true, false].include?(value)
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
    when :win_status, :change_status, :door_chosen
      instance_variable_get("@#{parameter}")
    else
      raise ArgumentError, "Неизвестный параметр #{parameter}"
    end
  end


  private

  attr_accessor :win_status, :change_status, :door_chosen
end
#Игрок. Реализовывать единый класс для игрока и ведущего нет смысла, общего слишком мало для полезности реализации
#Атрибуты - выиграл ли(bool), менял ли дверь(bool), выбранная дверь(int).
#Атрибут выигрыша нужен для статистики, проверки для devil варианта и для формирования выборки дверей для ведущего
# Атрибут смены двери нужен для статистики
# Атрибут выбранной двери используется многократно
# Нижний класс, доступ через get/set, сторонние функции не показались полезными.ArgumentError в возможных местах.
# Выиграл ли проверяется после первого выбора(для выбора ведущего) и после (если такая была) второго выбора.
# Задаётся после создания дверей и первого выбора игрока
# Менял ли - положительно при втором выборе игрока, изначально и в других вариантах отрицательно
# Выбранная дверь задаётся первым выбором после создания дверей.Меняется при втором выборе