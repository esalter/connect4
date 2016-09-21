require 'rspec'

describe 'API' do

  before do

  end

  it 'initial pageload should have empty game' do
    get '/'
    expect(last_response.body).to include('<table id="gameTable"></table>')
  end

  it 'getting a game should retrieve the json of the game state' do
    get '/game/1'
    expect(last_response.body).to eq('[["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""]]')
  end

  it 'initial pageload should have empty game if you go first' do
    post '/game', { difficulty: 'easy', first: true }
    expect(last_response.body).to eq('[["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""]]')
  end

  it 'initial pageload should have one move if computer goes first' do
    post '/game', { difficulty: 'hard', first: false }
    expect(last_response.body).to eq('[["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","X","","",""]]')
  end
end