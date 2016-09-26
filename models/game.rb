require 'benchmark'

class Game < ActiveRecord::Base
  has_many :moves, -> { order(:id) }
  after_initialize :create_state_data
  after_find :recreate_state

  def initialize_copy(orig)
    super
    @state = JSON.parse(orig.to_json)['state'].reverse
    @winner = nil # force recalc
  end

  def bot_move
    result = @ai.get_best(self, 2)
    place_token 2, result[:column]
  end

  # sets a token in the game board.  if update_db is true,
  # then also create the move in the db.
  # useful if we are loading from the db and just want to
  # reconstruct the game
  def place_token(player, column, update_db = true)
    # ensure a winner hasn't been found yet
    # we do need to use the getter (not the private var), because
    # it might not be calculated even if the winner has been determined.
    if winner == nil
      if player == current_player
        # find the first free slot.
        row = 0
        begin
          if @state[row][column] == ''
            @state[row][column] = player
            create_move player, column if update_db
            set_next_player
            return true
          end
          row += 1
        end until row >= self.rows
      end
    end

    false
  end

  def create_move(player, column)
    Move.create(player: player, column: column, game_id: self.id)
  end

  def next_player
    @current_player == 1 ? 2 : 1
  end

  def set_next_player
    @current_player = next_player
  end

  def current_player
    @current_player
  end

  # gets the tokens (or blanks) in a column, starting from the bottom.
  def get_column(index)
    column = []
    self.rows.times do |i|
      column.push(@state[i][index])
    end

    column
  end

  def score
    # attempts to score the current position of the board
    # human points (favorable positions for player 1) are negative
    # bot points (favorable positions for player 2) are positive
    # 10000 (-10000) points for a win condition board
    # other good positions, like having runs of 3 or even 2, are also given corresponding weights.
    scorer = Scorer.new(@state, self.rows, self.columns)
    player_wins = scorer.check_runs(1, 4)
    player_strong = scorer.check_runs(1, 3)
    player_established = scorer.check_runs(1, 2)
    bot_wins = scorer.check_runs(2, 4)
    bot_strong = scorer.check_runs(2, 3)

    if bot_wins > 0
        10000
    else
        (player_wins * -10000) + (player_strong * -100) - player_established + (bot_strong * 100)
    end
  end

  def full?
    (0..self.columns-1).each do |i|
      return false unless column_full?(i)
    end

    true
  end

  def column_full?(index)
    column = get_column(index)
    column[self.rows-1] != ''
  end

  def to_json(options = {})
    # we keep the state in a "reversed" manner (bottom-up) to keep things a bit easier to calculate
    # but we don't want to expose that to the consuming code which expects left-right top-down
    # interpretation.
    JSON.pretty_generate({state: @state.reverse, game_id: self.id, winner: winner}, options)
  end

  @winner = nil
  def winner
    if @winner == nil
      scorer = Scorer.new(@state, self.rows, self.columns)
      time = Benchmark.measure do
        @winner = scorer.find_win[:player]
      end
    end

    @winner
  end

  protected
  @initialized = false

  def create_state_data

    # since after_find happens before after_initialization, and we need to cover
    # the case where we are creating or finding a record, we need this
    # check for if we've already initialized.
    if !@initialized
      @state = []

      @current_player = self.first_player
      self.rows.times do |i|
        @state.push([])
        self.columns.times do |j|
          val = ''
          @state[i].push(val)
        end
      end

      level = case self.difficulty
        when 'easy'
          4
        when 'hard'
          6
        else 2
      end

      @ai = MiniMax.new(level)

      @initialized = true
    end
  end

  def recreate_state
    # need to initialize first
    create_state_data

    # walk through game by move and reconstitute the state of the game.
    self.moves.each do |row|
      self.place_token row.player, row.column, false
    end
  end
end