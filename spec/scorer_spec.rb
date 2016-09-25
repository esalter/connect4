require 'rspec'

describe 'Scorer' do
  it 'initial game state has score 0' do
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    expect(game.score(1)).to eq(0)
  end

  it 'run of 2 should have score of 1' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 3)
    expect(game.score(1)).to eq(1)
  end

  it 'run of 3 should have score of 102' do
    # 102 because it's a run of three, plus 2 runs of 2.  (whatever, close enough)
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 3)
    game.place_token(2, 4)
    game.place_token(1, 3)
    expect(game.score(1)).to eq(102)
  end

  it 'run of 4 should have score of 10203' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 3)
    game.place_token(2, 4)
    game.place_token(1, 3)
    game.place_token(2, 6)
    game.place_token(1, 3)
    expect(game.score(1)).to eq(10203)
  end

  it 'bot run of 4 means you lose' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 4)
    game.place_token(2, 2)
    game.place_token(1, 3)
    game.place_token(2, 2)
    expect(game.score(1)).to eq(-10000)
  end

  it 'run of 3 from the bot should be negative' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 5)
    game.place_token(1, 4)
    game.place_token(2, 5)
    game.place_token(1, 6)
    game.place_token(2, 5)

    expect(game.score(1)).to eq(-100)
  end

  it 'a wide gap conts as 1' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 5)
    game.place_token(1, 3)

    expect(game.score(1)).to eq(1)
  end

  it 'two of your tokens with an opposing token in between counts for 0 vertically' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 0)

    expect(game.score(1)).to eq(0)
  end

  it 'two of your tokens with an opposing token in between counts for 0 horizontally' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 1)
    game.place_token(1, 2)

    expect(game.score(1)).to eq(0)
  end

  it 'two of your tokens with an opposing token in between counts for 0 diagonally' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 1)
    game.place_token(1, 2)
    game.place_token(2, 2)
    game.place_token(1, 2)
    game.place_token(2, 1) # two in a row for the bot, not scored for anything.

    expect(game.score(1)).to eq(0)
  end

  it 'two of your tokens with an opposing token in between counts for 0 desc-diagonally' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 4)
    game.place_token(2, 3)
    game.place_token(1, 2)
    game.place_token(2, 2)
    game.place_token(1, 2)
    game.place_token(2, 3) # two in a row for the bot, not scored for anything.

    expect(game.score(1)).to eq(0)
  end
end