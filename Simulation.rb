require_relative 'game'

class Simulation
  def initialize (behaviour, num_games)
    raise ArgumentError, "Неверный вариант поведения ведущего" unless [:classic, :devil, :angel].include?(behaviour)
    raise ArgumentError, "Только положительное целочисленное" unless num_games.is_a?(Integer) && num_games > 0
    @behaviour = behaviour
    @num_games = num_games
    @wins_with_change = 0
    @losses_with_change = 0
    @wins_without_change = 0
    @losses_without_change = 0
    run_simulation
    print_results
  end

  def run_simulation
    @num_games.times do
      game = Game.new(@behaviour)
      game.simulate
      @wins_with_change += 1 if game.player.get(:win_status) && game.player.get(:change_status)
      @losses_with_change += 1 if !game.player.get(:win_status) && game.player.get(:change_status)
      @wins_without_change += 1 if game.player.get(:win_status) && !game.player.get(:change_status)
      @losses_without_change += 1 if !game.player.get(:win_status) && !game.player.get(:change_status)
    end
  end

  def print_results
    wins_with_change_percentage = (@wins_with_change.to_f / @num_games * 100).round(2)
    losses_with_change_percentage = (@losses_with_change.to_f / @num_games * 100).round(2)
    wins_without_change_percentage = (@wins_without_change.to_f / @num_games * 100).round(2)
    losses_without_change_percentage = (@losses_without_change.to_f / @num_games * 100).round(2)

    puts "Выигрыш без смены двери #{wins_without_change_percentage}% #{@wins_without_change} раз из #{@num_games}"
    puts "Выигрыш со сменой двери #{wins_with_change_percentage}% #{@wins_with_change} раз из #{@num_games}"
    puts "Проигрыш без смены двери #{losses_without_change_percentage}% #{@losses_without_change} раз из #{@num_games}"
    puts "Проигрыш со сменой двери #{losses_with_change_percentage}% #{@losses_with_change} раз из #{@num_games}"
  end
end


#Simulation.new(:classic, 10000)

#Высший класс.Запускает инициализированное количество раз симуляцию game, для каждой из которых ведётся статистика
# ArgumentError на задаваемом поведении(для всех num_games игр) и самом количестве игр
# run_simulation запускает цикл симуляций. num_Games раз создаёт игру с инициализированными условиями, после чего
# запускает её симуляцию. После всего этого собирается статистика о победе/поражении и условии(с или без смены)
# print_results. После цикла симуляций выводит статистику по всем num_games симуляциям