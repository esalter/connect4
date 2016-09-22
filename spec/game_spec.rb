require 'rspec'

describe 'GameState' do

  before do

  end

  it 'alternates play on legal move' do
    game = GameState.new(6, 7)
    expect(game.current_player).to eq(1)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    game.place_token(2, 3)
  end

  it 'does not allow a player to play if it is not their move' do
    game = GameState.new(6, 7)
    expect(game.current_player).to eq(1)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    expect(game.get_column(3)).to eq([1,'','','','',''])
  end

  it 'cannot fill column past top' do
    game = GameState.new(6, 7)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    game.place_token(2, 3)
    expect(game.current_player).to eq(1)
    game.place_token(1, 3)
    expect(game.current_player).to eq(1)
    expect(game.get_column(3)).to eq([1,2,1,2,1,2])
  end
end