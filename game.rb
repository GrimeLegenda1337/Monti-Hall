require_relative 'door'
require_relative 'player'

class Game
  attr_reader :doors, :player, :winning_door

  def initialize(behaviour)
    unless [:classic, :devil, :angel].include?(behaviour)
      raise ArgumentError, "Неизвестный вариант поведения ведущего #{behaviour}"
    end
    @doors = Array.new(3) { |i| Door.new(i + 1) }
    @winning_door = @doors.sample
    @winning_door.set(:win_status, true)
    @player = Player.new
    @host_behaviour = behaviour
  end

  def player_choose_door
    @player.set(:door_chosen, @doors.sample.get(:id))
  end

  def player_choose_door_2
    chosen_door_id = @player.get(:door_chosen)
    remaining_doors = @doors.reject do |door|
      door.get(:id) == chosen_door_id || door.get(:open_status)
    end
    if remaining_doors.any?
      new_door = remaining_doors.sample
      @player.set(:door_chosen, new_door.get(:id))
    end
  end

  def host_choose_door
    first_pick_id = @player.get(:door_chosen)
    host_last_doors = @doors.reject { |door| door.get(:id) == first_pick_id || door.get(:win_status) }
    if host_last_doors.size == 1
      host_chosen_door = host_last_doors.first
    else
      host_chosen_door = host_last_doors.sample
    end
    host_chosen_door.set(:open_status, true)
  end

  def check_win
    @player.set(:win_status, @player.get(:door_chosen) == @winning_door.get(:id))
  end

  def behaviour_variator
    check_win
    case @host_behaviour
    when :classic
      offer_change_classic
    when :devil
      offer_change_devil
    when :angel
      offer_change_angel
    else
      raise ArgumentError, "Неизвестный вариант поведения ведущего #{@host_behaviour}"
    end
  end

  def offer_change_classic
    host_choose_door
    change_decision = [true, false].sample
    if change_decision
      @player.set(:change_status, true)
      player_choose_door_2
    end
    check_win
  end

  def offer_change_devil
    if check_win
      host_choose_door
      @player.set(:change_status, [true, false].sample)
      player_choose_door_2 if @player.get(:change_status)
      check_win
    end
  end

  def offer_change_angel
    unless check_win
      host_choose_door
      change_decision = [true, false].sample
      @player.set(:change_status, change_decision)
      player_choose_door_2 if change_decision
      check_win
    end
  end

  def simulate
    player_choose_door
    behaviour_variator
  end
end

# Основной класс симуляции игры.Подготавливает начальные условия в инициализации
#и воспроизводит симуляцию через функцию simulate
#Инициализирует три двери, одну из которых помечает как выигрышную, также создаётся игрок и "ведущий", как часть игры
# с определённым паттерном поведения. def player_choose_door - функция первого выбора игрока.
# def player_choose_door_2 - функция повторного выбора игрока.Меняет атрибут смены двери и выбирает двери из тех
# что не открыты(т.е. не выбраны ведущим) и уже не были выбраны.Т.е. происходит смена. Возможен вариант с выбором более
# чем из одной двери
# host_choose_door - работает по аналогии со вторым выбором игрока. Не занесена в инициализацию т.к. существует вариант
# без предложения перевыбора игроку с выходом сразу на победу/поражение
# check_win Проверяет, верную ли дверь выбрал игрок и задаёт ему статус. Может сработать до двух раз. Не срабатывает
# до вариатора(ниже), ведь ошибка может сработать раньше, чем эта функция понадобится
# simulate - запускает выполнение симуляции после задания изначальных данных в инициализации. Запускается через верхний класс
# behaviour_variator - вариатор, в зависимости от заданного для симуляций поведения, выполняет определённую функцию поведения
# offer_change_classic - классический "цикл поведения" в Парадоксе.
# Выбор игрока - всегда выбор ведущего и открытие - предложение смены - да/нет - результат
# offer_change_devil - вариант против игрока.
# Выбор игрока - если игрок выбрал правильное - предложение смены - да/нет - результат. Если игрок изначально выбрал
# неверную дверь - выход на проигрыш.
# offer_change_angel - вариант за игрока.
# Выбор игрока - если игрок ошибся - предложение смены - да/нет- результат. Если игрок верен в первый раз - выход на победу
# classic увеличивает шансы победы при согласии смены
# devil приравнивает к нулю шансы победы при согласии смены(ведь изначально выбран верный вариант)
# angel приравнивает к нулю шанс поражение при согласии смены(ведь изначально выбран проигрышный вариант)
# ArgumentError только на задаваемый в высшем классе behaviour