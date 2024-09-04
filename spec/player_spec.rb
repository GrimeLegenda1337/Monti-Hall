require 'rspec'
require_relative '../player.rb'

RSpec.describe Player do
  let(:player) { Player.new }
  describe '#initialize' do
  it 'init with def valuse' do
    expect(player.get(:win_status)).to be_falsey
    expect(player.get(:change_status)).to be_falsey
    expect(player.get(:door_chosen)).to be_nil
  end
  end
end
