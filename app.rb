require 'sinatra/base'
require 'sinatra/param'
#require 'json'
require 'sinatra/json'
require 'sinatra/activerecord'

require './lib/game_state'
require './models/game'
require './models/move'

class Connect4 < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  helpers Sinatra::Param

  before do
    content_type :json
  end

  get '/' do
    content_type :html
    erb :index
  end

  get '/game/:id' do |id|
    param :id,        Integer
    begin
      game = Game.find id, include: :moves

      game_state = GameState.new

      # walk through game by move
      game.moves.each do |row|
        game_state.place_token row.player, row.column
      end

      json game_state

    rescue ActiveRecord::RecordNotFound
      status 400
      json "errors": "game not found"
    end

  end

  post '/game' do
    param :difficulty, String, in: ["easy", "hard"], transform: :downcase, default: "easy"
    param :first, Boolean, default: true

    first_player = params[:first] ? 1 : 2
    game = GameState.new 6, 7, first_player

    game.place_token(2, 3) unless params[:first]
    json game
  end
end