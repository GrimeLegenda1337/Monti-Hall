require 'rspec'
require_relative '../door.rb'

RSpec.describe Door do
  let(:door) { Door.new(1) }

  describe '#init' do
    it 'инициализация с id' do
      expect(door.get(:id)).to eq(1)
      expect(door.get(:win_status)).to be_falsey
      expect(door.get(:open_status)).to be_falsey
    end
    it 'вызывает ошибку при инициализации с нецелочисленным id' do
      expect { Door.new('invalid') }.to raise_error(ArgumentError, "Допустим только целочисленный тип данных")
    end
  end
  describe '#set' do
    it 'вызывает ошибку при попытке изменить id' do
      expect { door.set(:id, 2) }.to raise_error(ArgumentError, "Запрет на изменение параметра id")
    end
    it 'вызывает ошибку при неверных значениях для win_status и open_status' do
      expect { door.set(:win_status, 'invalid') }.to raise_error(ArgumentError)
      expect { door.set(:open_status, 1) }.to raise_error(ArgumentError)
    end
    it 'вызывает ошибку при неизвестном параметре' do
      expect { door.set(:unknown_param, true) }.to raise_error(ArgumentError, "Неизвестный параметр unknown_param")
    end
    it 'корректно устанавливает win_status и open_status при правильных значениях' do
      expect { door.set(:win_status, true) }.not_to raise_error
      expect { door.set(:open_status, false) }.not_to raise_error
      expect(door.get(:win_status)).to be true
      expect(door.get(:open_status)).to be false
    end
  end
  describe '#get' do
    it 'возвращает корректные значения для параметров id, win_status, open_status' do
      expect(door.get(:id)).to eq(1)
      door.set(:win_status, true)
      expect(door.get(:win_status)).to be true
      door.set(:open_status, true)
      expect(door.get(:open_status)).to be true
    end
    it 'вызывает ошибку при неизвестном параметре' do
      expect { door.get(:unknown_param) }.to raise_error(ArgumentError, "Неизвестный параметр unknown_param")
    end
  end
  describe 'Попытка доступа напрямую' do
    it 'Ошибка при попытка доступа к атрибутам класса' do
      expect { door.id }.to raise_error(NoMethodError)
      expect { door.win_status }.to raise_error(NoMethodError)
      expect { door.open_status }.to raise_error(NoMethodError)
    end
  end
end