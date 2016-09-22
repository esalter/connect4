require 'sinatra/base'
require 'sinatra/param'
#require 'json'
require 'sinatra/json'
require 'sinatra/activerecord'

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

    game.place_token(2, 3) unless params[:first_player] == 1
    json game
  end

  post '/game/:game_id/move' do
    param :game_id, Integer
    param :column, Integer
    begin
      game = Game.includes(:moves).find(params[:game_id])

      game.place_token 1, params[:column]

      json game

    #rescue ActiveRecord::RecordNotFound
    #  status 400
    #  json "errors": "game not found"
    end
  end
end