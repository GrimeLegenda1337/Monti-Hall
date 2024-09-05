require 'rspec'
require_relative '../door.rb'
require_relative '../player.rb'
require_relative '../game.rb'


RSpec.describe Game do
  it 'Ошибка зависимости player и door' do
    Object.send(:remove_const,:Player) if defined?(Player)
    expect{Game.new(:classic)}.to raise_error(NameError)
    load 'player.rb'
    Object.send(:remove_const,:Door) if defined?(Door)
    expect{Game.new(:classic)}.to raise_error(NameError)
    load 'door.rb'
  end
  describe '#init' do
    let(:game) { Game.new(:classic) }
    it 'задаётся поведение ведущего или выдаётся ошибка' do
      expect(Game.new(:classic).instance_variable_get(:@host_behaviour)).to eq(:classic)
      expect(Game.new(:devil).instance_variable_get(:@host_behaviour)).to eq(:devil)
      expect(Game.new(:angel).instance_variable_get(:@host_behaviour)).to eq(:angel)
      expect{Game.new(:invalid)}.to raise_error(ArgumentError, "Неизвестный вариант поведения ведущего invalid")
    end
    it 'создаёт массив из трёх дверей c id 1,2,3 , одна из которых с выигрышем' do
      doors = game.instance_variable_get(:@doors)
      winning_door = game.instance_variable_get(:@winning_door)
      expect(doors.size).to eq(3)
      doors.each do |door| expect(door).to be_instance_of(Door) end
      doors.each do |door| expect([1, 2, 3]).to include(door.get(:id)) end
      expect(winning_door.get(:win_status)).to be_truthy
    end
    it 'создаётся игрок, выбор двери(первый и последующий не происходит в инициализации' do
      expect(game.instance_variable_get(:@player)).to be_instance_of(Player)
      expect(game.instance_variable_get(:@player).get(:win_status)).to be_falsey
      expect(game.instance_variable_get(:@player).get(:change_status)).to be_falsey
    end
  end
  describe '#player_choose_door' do
    it 'Дверь игроком выбирается из трёх существующих дверей' do
      game = Game.new(:classic);player = game.instance_variable_get(:@player)
      game.player_choose_door
      id = player.get(:door_chosen);doors_id = game.instance_variable_get(:@doors).map {|door| door.get(:id) }
      expect(doors_id).to include(id)
    end
  end
  describe '#host_choose_door' do
    it 'Дверь ведущим выбирается такая, что не выигрышная, и не выбрана игроком.' do
      game = Game.new(:classic)
      player = game.instance_variable_get(:@player)
      doors = game.instance_variable_get(:@doors)
      game.player_choose_door
      winning_door = game.instance_variable_get(:@winning_door)
      winning_door.set(:win_status, true)

      game.host_choose_door
      chosen_door = doors.find { |door| door.get(:open_status) }

      expect(doors.reject { |door| door.get(:id) == player.get(:door_chosen) || door.get(:win_status) }).to include(chosen_door)
      expect(chosen_door.get(:open_status)).to be_truthy
    end
  end
  describe '#player_choose_door_2' do
    it 'Игрок во второй раз(если предложено и если согласился) выбирает дверь из оставшихся,
        ту что ещё не выбирал и ту, что не открыта(её выбирал ведущий' do
      game = Game.new(:classic)
      player = game.instance_variable_get(:@player)
      doors = game.instance_variable_get(:@doors)
      winning_door = game.instance_variable_get(:@winning_door)
      game.player_choose_door
      first_choice = player.get(:door_chosen)
      game.host_choose_door
      host_choice = doors.find { |door| door.get(:open_status) }
      game.player_choose_door_2
      second_choice = player.get(:door_chosen)
      expect(second_choice).not_to eq(first_choice)
      expect(second_choice).not_to eq(host_choice)
    end
  end
  describe '#behaviour_variator' do
    it 'Верно обрабатывает все известные ему варианты' do
      [:classic,:devil,:angel].each do |behaviour|
        game = Game.new(behaviour)
        expect{game.simulate}.to_not raise_error
      end
    end
    it 'Вызывает ошибку для неизвестного поведения' do
      expect{Game.new(:unknown).simulate}.to raise_error(ArgumentError,"Неизвестный вариант поведения ведущего #{:unknown}")
    end
    it 'Собственная функция достоверно сработает для каждого случая поведения' do
      [:classic, :devil, :angel].each do |behaviour|
        game = Game.new(behaviour)
        allow(game).to receive(:offer_change_classic)
        allow(game).to receive(:offer_change_devil)
        allow(game).to receive(:offer_change_angel)

        case behaviour
        when :classic
          game.simulate
          expect(game).to have_received(:offer_change_classic).once
        when :devil
          game.simulate
          expect(game).to have_received(:offer_change_devil).once
        when :angel
          game.simulate
          expect(game).to have_received(:offer_change_angel).once
        end
      end
    end
  end
end