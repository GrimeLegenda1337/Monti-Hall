require 'rspec'
require_relative '../simulation'
require_relative '../game'

RSpec.describe Simulation do
  before(:all) do # заданные для цикла цикла симуляций параметры, будем проверять гипотезы на большой выборке
    @behaviours = [:classic, :devil, :angel] # ниже будем проверять условия и для каждой из симуляции и для общего
    @simulations_per_behaviour = 100
    @num_games = 10000
  end

  it 'Ошибка зависимости' do #проверка на ошибку отстутствия класса симуляции игры
    Object.send(:remove_const, :Game) if defined?(Game)
    expect { Simulation.new(:classic, @num_games) }.to raise_error(NameError)
    load 'game.rb'
  end

  describe '#init' do
    it 'Ошибка поведения ведущего' do #проверка на незнакомый вариант поведения в симуляции
      expect { Simulation.new(:invalid, @num_games) }.to raise_error(ArgumentError, "Неверный вариант поведения ведущего")
    end

    it 'Ошибка числового значения игр' do #проверка на попытку ввести нечисловое значение игр
      expect { Simulation.new(:classic, 'aaa') }.to raise_error(ArgumentError, "Только положительное целочисленное")
    end

    it 'Ошибка неположительного значения игр' do #проверка на  [1;inf], не сработает с 0 и отрицательными
      expect { Simulation.new(:classic, -5) }.to raise_error(ArgumentError, "Только положительное целочисленное")
    end
  end

  describe '#run_simulation' do
    before(:each)
      @simulations = {}
      @behaviours.each do |behaviour|
        @simulations[behaviour] = Array.new(@simulations_per_behaviour) { Simulation.new(behaviour, @num_games) }
      end # будем проверять каждый вариант поведения
    end

    it 'Каждая симуляция должна корректно выполняться и не выдавать ошибок' do
      @simulations.each do |behaviour, sims|
        sims.each do |sim|
          expect { sim.run_simulation }.not_to raise_error
        end #ни одна из симуляций не должна выдать ошибку при любом верном behaviour
      end
    end

    it 'Количество посчитанных игр совпадает с заданным количеством игр' do
      @simulations.each do |behaviour, sims|
        sims.each do |sim|
          total_games = sim.instance_variable_get(:@wins_with_change) +
            sim.instance_variable_get(:@losses_with_change) +
            sim.instance_variable_get(:@wins_without_change) +
            sim.instance_variable_get(:@losses_without_change)
          expect(total_games).to eq(sim.instance_variable_get(:@num_games))
        end #если все игры без ошибок - то у них есть исход,который собран статистикой
      end   # проверяем совпадение количества всех прогнанных симуляций и всех собранных результатов
    end

    context 'Для поведения classic' do
      it 'Выигрыши со сменой больше выигрышей без смены' do
        @simulations[:classic].each do |sim|
          expect(sim.instance_variable_get(:@wins_with_change)).to be > sim.instance_variable_get(:@wins_without_change)
        end # на каждом цикле симуляций(10000) проверяем классическую гипотезу(улучшение результата от смены выбора)
      end

      it 'Суммарные выигрыши со сменой больше суммарных выигрышей без смены' do
        total_wins_with_change = @simulations[:classic].sum { |sim| sim.instance_variable_get(:@wins_with_change) }
        total_wins_without_change = @simulations[:classic].sum { |sim| sim.instance_variable_get(:@wins_without_change) }
        expect(total_wins_with_change).to be > total_wins_without_change
      end #также проверим гипотезу для цикла цикла симуляций
    end

    context 'Для поведения devil' do
      it 'Количество выигрышей со сменой двери равно 0' do
        @simulations[:devil].each do |sim|
          expect(sim.instance_variable_get(:@wins_with_change)).to eq(0)
        end # проверяем очевидное, нельзя выиграть от смены двери, если изначальная выигрышная,
                                                                             #открытая ложная и оставшаяся ложная
      end

      it 'Суммарное количество выигрышей со сменой двери равно 0' do
        total_wins_with_change = @simulations[:devil].sum { |sim| sim.instance_variable_get(:@wins_with_change) }
        expect(total_wins_with_change).to eq(0)
      end # и для цикла цикла симуляций
    end

    context 'Для поведения angel' do
      it 'Количество проигрышей со сменой двери равно 0' do
        @simulations[:angel].each do |sim|
          expect(sim.instance_variable_get(:@losses_with_change)).to eq(0)
        end # аналогично, нельзя проиграть от смены двери, если изначально ошибся и одну ложную показали
      end

      it 'Суммарное количество проигрышей со сменой двери равно 0' do
        total_losses_with_change = @simulations[:angel].sum { |sim| sim.instance_variable_get(:@losses_with_change) }
        expect(total_losses_with_change).to eq(0)
      end # и для высшего цикла
    end
  end
end