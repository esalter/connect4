require 'rspec'

describe 'MinMax spec' do
  it 'it picks the winning move from a run of 3' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 5)
    game.place_token(1, 4)
    game.place_token(2, 5)
    game.place_token(1, 6)
    game.place_token(2, 5)
    game.place_token(1, 0)

    minmax = MiniMax.new(2)
    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(5)
  end

  it 'it picks the winning move from a run of 3 - easy, take 2' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 2)
    minmax = MiniMax.new(2)
    game.place_token(2, 3)
    game.place_token(1, 6)
    game.place_token(2, 0)
    game.place_token(1, 6)
    game.place_token(2, 0)
    game.place_token(1, 6)

    # it needs to block the next move
    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(6)

    game.place_token(2, 6)
    game.place_token(1, 6)
    game.place_token(2, 0)
    game.place_token(1, 6)

    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(0)
  end

  it 'it picks the winning move from a run of 3 - hard, take 2' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'hard', first_player: 2)
    minmax = MiniMax.new(4)
    game.place_token(2, 3)
    game.place_token(1, 6)
    game.place_token(2, 0)
    game.place_token(1, 6)
    game.place_token(2, 0)
    game.place_token(1, 6)

    # it needs to block the next move
    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(6)

    game.place_token(2, 6)
    game.place_token(1, 6)
    game.place_token(2, 0)
    game.place_token(1, 6)

    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(0)
  end

  it 'it blocks a sure win' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7, difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 5)
    game.place_token(1, 0)
    game.place_token(2, 5)
    game.place_token(1, 0)

    minmax = MiniMax.new(2)
    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(0)
  end

  it 'it picks the winning move from an almost full board' do
    allow(Move).to receive(:create) { }
    game = Game.new(rows:6,columns:7,difficulty:'easy', first_player: 1)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 0)
    game.place_token(2, 0)
    game.place_token(1, 0)
    game.place_token(2, 0)
    # 1st column full

    game.place_token(1, 2)
    game.place_token(2, 1)
    game.place_token(1, 1)
    game.place_token(2, 1)
    game.place_token(1, 1)
    # 2nd column prepped for winning move

    game.place_token(2, 2)
    game.place_token(1, 2)
    game.place_token(2, 2)
    game.place_token(1, 3)
    game.place_token(2, 2)
    game.place_token(1, 4)
    game.place_token(2, 2)
    # 3rd column full, most of bottom done

    game.place_token(1, 4)
    game.place_token(2, 5)
    game.place_token(1, 5)
    game.place_token(2, 5)
    game.place_token(1, 5)
    game.place_token(2, 5)
    game.place_token(1, 5)
    # 5th column done

    game.place_token(2, 6)
    game.place_token(1, 6)
    game.place_token(2, 6)
    game.place_token(1, 6)
    game.place_token(2, 6)
    # top-right still open

    game.place_token(1, 4)
    game.place_token(2, 3)
    game.place_token(1, 3)
    game.place_token(2, 3)
    game.place_token(1, 3)
    game.place_token(2, 4)
    game.place_token(1, 4)
    game.place_token(2, 3)
    game.place_token(1, 1)

    # the winning move
    #game.place_token(2, 1)
    # the non-winning move, leads to draw or non-guaranteed win.
    #game.place_token(2, 6)
    # another non-guaranteed-win move
    #game.place_token(2, 4)

    expect(game.winner).to eq(nil)

    expect(game.column_full?(0)).to equal(true)
    expect(game.column_full?(1)).to equal(false)
    expect(game.column_full?(2)).to equal(true)
    expect(game.column_full?(3)).to equal(true)
    expect(game.column_full?(4)).to equal(false)
    expect(game.column_full?(5)).to equal(true)
    expect(game.column_full?(6)).to equal(false)
    # columns 1, 4, 6 are available.  1 results in the win

    minmax = MiniMax.new(1)
    result = minmax.get_best(game, 2)
    expect(result[:column]).to eq(1)
  end
end