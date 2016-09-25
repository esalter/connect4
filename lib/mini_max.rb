
class MiniMax
  def initialize(max_depth = 2)
    @max_depth = max_depth
  end

  def get_best(game, player)
    start_depth = @max_depth
    moves = []
    (0..game.columns-1).each do |i|
      unless game.column_full?(i)
        new_game = game.clone
        new_game.place_token(player, i, false)
        score = search(start_depth - 1, new_game, player == 1 ? 2 : 1) * -1
        moves.push({ score: score, column: i })
      end
    end

    best_score = -99999999
    best_move = nil
    moves.shuffle.each do |item|
      if item[:score] > best_score
        best_score = item[:score]
        best_move = item[:column]
      end
    end

    { column: best_move, score: best_score }
  end

  def search(depth, game, player)
    moves = []
    (0..game.columns-1).each do |i|

      unless game.column_full?(i)
        new_game = game.clone
        new_game.place_token(player, i, false)
        moves.push(new_game)
      end
    end

    if depth <= 0 or moves.length == 0 or game.winner != nil
      score = game.score(player)
      return score
    end

    score = -99999999
    moves.each do |child_game|
      unless child_game == nil
        searched_score = self.search(depth-1, child_game, player == 1 ? 2 : 1)
        reversed_score = searched_score * -1
        score = [score, reversed_score].max
      end
    end

    score
  end
end
