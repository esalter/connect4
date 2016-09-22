require 'rspec'

describe 'API' do

  before do

  end

  it 'initial pageload should have empty game' do
    get '/'
    expect(last_response.body).to include('<table id="gameTable"></table>')
  end

  it 'non existent game should return 400' do
    get '/game/111111'
    expect(last_response.status).to eq(400)
    expect(last_response.body).to eq({
                                         errors: "game not found"
                                     }.to_json)

  end

  it 'initial pageload should have empty game if you go first' do
    post '/game', { difficulty: 'easy', first: true }
    game = GameState.new(6, 7)
    expect(last_response.body).to eq(game.to_json)
  end

  it 'initial pageload should have one move if computer goes first' do
    post '/game', { difficulty: 'hard', first: false }

    game = GameState.new(6, 7, 2)
    game.place_token(2, 3)
    expect(last_response.body).to eq(game.to_json)
  end
end