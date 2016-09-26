
class MiniMax
  def initialize(max_depth = 2)
    @max_depth = max_depth
  end

  def finished?(score, game, depth)
    depth <= 0 or game.full? or game.winner != nil or (score >= 10000 or score <= -10000)
  end

  def get_best (game, player)
    maximize(@max_depth, game, player, -999999, 999999)
  end

  def maximize(depth, game, player, alpha, beta)
    score = game.score

    return { score: score, column: nil } if finished?(score, game, depth)
    result = {column: nil, score: -99999999}

    (0..game.columns-1).each do |i|
      new_game = game.clone
      if new_game.place_token(player, i, false)
        proposed_move = self.minimize(depth - 1, new_game, player == 1 ? 2 : 1, alpha, beta)
        if result[:column] == nil || proposed_move[:score] > result[:score]
          result[:column] = i
          result[:score] = alpha = proposed_move[:score]
        end
      end

      short_circuit = alpha >= beta
      return result if short_circuit
    end

    result
  end

  def minimize(depth, game, player, alpha, beta)
    score = game.score

    return { score: score, column: nil } if finished?(score, game, depth)
    result = { column: nil, score: 99999999 }
    (0..game.columns-1).each do |i|
      new_game = game.clone
      if new_game.place_token(player, i, false)
        proposed_move = self.maximize(depth - 1, new_game, player == 1 ? 2 : 1, alpha, beta)
        if result[:column] == nil || proposed_move[:score] < result[:score]
          result[:column] = i
          result[:score] = beta = proposed_move[:score]
        end
      end

      short_circuit = alpha >= beta
      return result if short_circuit
    end

    result
  end
end
