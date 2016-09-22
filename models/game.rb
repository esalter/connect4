class Game < ActiveRecord::Base
  has_many :moves, -> { order(:id) }
end