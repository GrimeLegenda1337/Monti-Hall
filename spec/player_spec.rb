require 'rspec'
require_relative '../player.rb'

RSpec.describe Player do
  let(:player) { Player.new }
  describe '#init' do
  it 'initialization with def (false,false,nil) values' do
    expect(player.get(:win_status)).to be_falsey
    expect(player.get(:change_status)).to be_falsey
    expect(player.get(:door_chosen)).to be_nil
  end
  end
  describe '#set' do
    it 'Ошибка для win_status и change_status по отсуствию true/false' do
      expect{player.set(:win_status,'invalid')}.to raise_error ArgumentError
      expect{player.set(:win_status,'nil')}.to raise_error ArgumentError
      expect{player.set(:change_status,'invalid')}.to raise_error ArgumentError
      expect{player.set(:change_status,'invalid')}.to raise_error ArgumentError
    end
    it 'Ошибка для door_chosen отличных от 1,2,3' do
      expect{player.set(:door_chosen,4)}.to raise_error ArgumentError
      expect{player.set(:door_chosen,-1)}.to raise_error ArgumentError
      expect{player.set(:door_chosen,'a')}.to raise_error ArgumentError
    end
    it 'Ошибка неизвестного параметра' do
      expect{player.set(:unknown_parameter,true)}.to raise_error ArgumentError
    end
    it 'Нормальная работа set при верных данных' do
      expect{player.set(:win_status, true) }.not_to raise_error
      expect{player.set(:change_status, false) }.not_to raise_error
      expect{player.set(:door_chosen, 2) }.not_to raise_error
      expect(player.get(:win_status)).to be true
      expect(player.get(:change_status)).to be false
      expect(player.get(:door_chosen)).to eq(2)
    end
  end
  describe '#get' do
    it 'Нормальная работа при правильном параметре' do
      test_data = {
        win_status: [true,false],
        change_status: [true,false],
        door_chosen: [1,2,3]
      }
      test_data.each do |param, values|
        values.each do |value|
          player.set(param, value)
          expect(player.get(param)).to eq(value)
        end
      end
    end
    it 'Ошибка неизвестного параметра' do
      expect { player.get(:unknown_param) }.to raise_error(ArgumentError)
    end
  end
  describe 'Попытка доступа напрямую' do
    it 'Ошибка при попытка доступа к атрибутам класса' do
      expect { player.win_status }.to raise_error(NoMethodError)
      expect { player.change_status }.to raise_error(NoMethodError)
      expect { player.door_chosen }.to raise_error(NoMethodError)
    end
  end
end
