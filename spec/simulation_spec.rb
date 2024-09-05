require 'rspec'
require_relative '../simulation'
require_relative '../game'

RSpec.describe Simulation do
  before(:all) do
    @behaviours = [:classic, :devil, :angel]
    @simulations_per_behaviour = 100
    @num_games = 10000
  end

  it 'Ошибка зависимости' do
    Object.send(:remove_const, :Game) if defined?(Game)
    expect { Simulation.new(:classic, @num_games) }.to raise_error(NameError)
    load 'game.rb'
  end

  describe '#init' do
    it 'Ошибка поведения ведущего' do
      expect { Simulation.new(:invalid, @num_games) }.to raise_error(ArgumentError, "Неверный вариант поведения ведущего")
    end

    it 'Ошибка числового значения игр' do
      expect { Simulation.new(:classic, 'aaa') }.to raise_error(ArgumentError, "Только положительное целочисленное")
    end

    it 'Ошибка неположительного значения игр' do
      expect { Simulation.new(:classic, -5) }.to raise_error(ArgumentError, "Только положительное целочисленное")
    end
  end

  describe '#run_simulation' do
    before(:each) do
      @simulations = {}
      @behaviours.each do |behaviour|
        @simulations[behaviour] = Array.new(@simulations_per_behaviour) { Simulation.new(behaviour, @num_games) }
      end
    end

    it 'Каждая симуляция должна корректно выполняться и не выдавать ошибок' do
      @simulations.each do |behaviour, sims|
        sims.each do |sim|
          expect { sim.run_simulation }.not_to raise_error
        end
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
        end
      end
    end

    context 'Для поведения classic' do
      it 'Выигрыши со сменой больше выигрышей без смены' do
        @simulations[:classic].each do |sim|
          expect(sim.instance_variable_get(:@wins_with_change)).to be > sim.instance_variable_get(:@wins_without_change)
        end
      end

      it 'Суммарные выигрыши со сменой больше суммарных выигрышей без смены' do
        total_wins_with_change = @simulations[:classic].sum { |sim| sim.instance_variable_get(:@wins_with_change) }
        total_wins_without_change = @simulations[:classic].sum { |sim| sim.instance_variable_get(:@wins_without_change) }
        expect(total_wins_with_change).to be > total_wins_without_change
      end
    end

    context 'Для поведения devil' do
      it 'Количество выигрышей со сменой двери равно 0' do
        @simulations[:devil].each do |sim|
          expect(sim.instance_variable_get(:@wins_with_change)).to eq(0)
        end
      end

      it 'Суммарное количество выигрышей со сменой двери равно 0' do
        total_wins_with_change = @simulations[:devil].sum { |sim| sim.instance_variable_get(:@wins_with_change) }
        expect(total_wins_with_change).to eq(0)
      end
    end

    context 'Для поведения angel' do
      it 'Количество проигрышей со сменой двери равно 0' do
        @simulations[:angel].each do |sim|
          expect(sim.instance_variable_get(:@losses_with_change)).to eq(0)
        end
      end

      it 'Суммарное количество проигрышей со сменой двери равно 0' do
        total_losses_with_change = @simulations[:angel].sum { |sim| sim.instance_variable_get(:@losses_with_change) }
        expect(total_losses_with_change).to eq(0)
      end
    end
  end
end