require 'sinatra/base'
require 'sinatra/param'
require 'json'

class Connect4 < Sinatra::Base
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
    game = '[["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""],["","","","","","",""]]'

    game
  end

  post '/game' do
    param :difficulty, String, in: ["easy", "hard"], transform: :downcase, default: "easy"
    param :first, Boolean, default: true

    game = []
    (0..5).each do |i|
      game.push([])
      (0..6).each do |j|
        val = ''
        if i == 5 && j==3 && !params[:first]
          val = 'X'
        end

        game[i].push(val)
      end
    end

    game.to_json
  end

end