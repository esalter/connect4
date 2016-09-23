require 'rspec'

describe 'GameState' do

  before do

  end

  it 'alternates play on legal move' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows: 6, columns:7, difficulty: 'easy', first_player: 1)
    expect(game.current_player).to eq(1)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    game.place_token(2, 3)
    expect(game.current_player).to eq(1)
  end

  it 'detects when a column is full' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows: 6, columns:7, difficulty: 'easy', first_player: 1)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 3)
    expect(game.column_full?(3)).to eq(false)
    game.place_token(2, 3)
    expect(game.column_full?(3)).to eq(true)
  end

  it 'does not allow a player to play if it is not their move' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows: 6, columns:7, difficulty: 'easy', first_player: 1)
    expect(game.current_player).to eq(1)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    game.place_token(1, 3)
    expect(game.current_player).to eq(2)
    expect(game.get_column(3)).to eq([1,'','','','',''])
  end

  it 'cannot fill column past top' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows: 6, columns:7, difficulty: 'easy', first_player: 1)
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