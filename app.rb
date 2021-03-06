require 'sinatra/base'
require 'sinatra/param'
#require 'json'
require 'sinatra/json'
require 'sinatra/activerecord'

require './lib/scorer'
require './lib/mini_max'
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

  get '/game' do
    games = Game.pluck(:id)
    json games
  end

  get '/game/:id' do |id|
    param :id,        Integer
    begin
      game = Game.includes(:moves).find(id)
      json game
    rescue ActiveRecord::RecordNotFound
      status 400
      json "errors": "game not found"
    end

  end

  post '/game' do
    param :difficulty, String, in: ["easy", "hard"], transform: :downcase, default: "easy"
    param :first_player, Integer, default: true
    param :rows, Integer, default: 6
    param :columns, Integer, default: 7

    game = Game.create(params)

    # hard-code the best opening move to help the AI along.
    game.place_token(2, params[:columns]/2) unless params[:first_player] == 1
    json game
  end

  post '/game/:game_id/move' do
    param :game_id, Integer
    param :column, Integer
    begin
      game = Game.includes(:moves).find(params[:game_id])

      # did the player make a valid move?
      # its not actually necessary to do this check, but it saves bot
      # computation if the player didn't make a valid move.
      if game.place_token 1, params[:column]
        # now have the computer make a move.
        # note, it's possible at the moment for the computer
        # to try to make an illegal move (if a column is full)
        # in that case, nothing will happen, and the game will
        # stall because it won't retry at the moment.
        game.bot_move
      end

      json game

    rescue ActiveRecord::RecordNotFound
      status 400
      json "errors": "game not found"
    end
  end
end