require 'rspec'

describe 'Game Winner' do

  before do
  end

  after do
  end

  it 'detects upper left horizontal' do
    allow(Move).to receive(:create) { }

    game = Game.new(rows:6,columns:7,difficulty:'random', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 1)
    game.place_token(2, 1)
    game.place_token(1, 1)
    game.place_token(2, 1)
    game.place_token(1, 1)
    game.place_token(2, 1)
    game.place_token(1, 2)
    game.place_token(2, 5)
    game.place_token(1, 2)
    game.place_token(2, 2)
    game.place_token(1, 2)
    game.place_token(2, 2)
    game.place_token(1, 5)
    game.place_token(2, 2)
    game.place_token(1, 5)
    game.place_token(2, 3)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 5)
    expect(game.winner).to eq(nil)
    game.place_token(2, 3)

    expect(game.winner).to eq(2)
  end

  it 'detects upper left vertical' do
    allow(Move).to receive(:create) { }

    game = Game.new(rows:6,columns:7,difficulty:'random', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 0)
    game.place_token(2, 1)
    game.place_token(1, 0)
    game.place_token(2, 1)
    game.place_token(1, 0)
    game.place_token(2, 1)
    expect(game.winner).to eq(nil)
    game.place_token(1, 0)

    expect(game.winner).to eq(1)
  end

  it 'detects upper right vertical' do
    allow(Move).to receive(:create) { }

    game = Game.new(rows:6,columns:7,difficulty:'random', first_player: 1)
    game.place_token(1, 6)
    game.place_token(2, 6)
    game.place_token(1, 6)
    game.place_token(2, 1)
    game.place_token(1, 6)
    game.place_token(2, 1)
    game.place_token(1, 6)
    game.place_token(2, 1)
    expect(game.winner).to eq(nil)
    game.place_token(1, 6)

    expect(game.winner).to eq(1)
  end

  it 'detects middle ascending diag' do
    allow(Move).to receive(:create) { }

    game = Game.new(rows:6, columns:7, difficulty:'random', first_player: 1)
    game.place_token(1, 6)
    game.place_token(2, 6)
    game.place_token(1, 6)
    game.place_token(2, 1)
    game.place_token(1, 6)
    game.place_token(2, 1)
    game.place_token(1, 6)
    game.place_token(2, 1)
    expect(game.winner).to eq(nil)
    game.place_token(1, 6)

    expect(game.winner).to eq(1)
  end

  it 'detects middle desc diag' do
    allow(Move).to receive(:create) { }

    game = Game.new(rows:6,columns:7,difficulty:'random', first_player: 1)
    game.place_token(1, 2)
    game.place_token(2, 1)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 1)
    game.place_token(2, 3)
    game.place_token(1, 1)
    game.place_token(2, 1)
    game.place_token(1, 1)
    game.place_token(2, 0)
    game.place_token(1, 2)
    game.place_token(2, 0)
    game.place_token(1, 2)
    game.place_token(2, 5)
    game.place_token(1, 3)
    game.place_token(2, 4)
    game.place_token(1, 3)
    game.place_token(2, 4)
    expect(game.winner).to eq(nil)
    game.place_token(1, 4)

    expect(game.winner).to eq(1)
  end
end