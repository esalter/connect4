require 'benchmark'

class Game < ActiveRecord::Base
  has_many :moves, -> { order(:id) }
  after_initialize :create_state_data
  after_find :recreate_state

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

  def to_json(options = {})
    # we keep the state in a "reversed" manner (bottom-up) to keep things a bit easier to calculate
    # but we don't want to expose that to the consuming code which expects left-right top-down
    # interpretation.
    JSON.pretty_generate({state: @state.reverse, game_id: self.id, winner: winner}, options)
  end

  @winner = nil
  def winner
    if @winner == nil
      time = Benchmark.measure do
        @winner = find_win
      end

      puts "Found result of game in #{time}"
    end

    @winner
  end

  protected
  @initialized = false
  def find_win
    winner = nil

    # check win conditions, then recursion.
    self.rows.times do |i|
      self.columns.times do |j|

        winner = check_horizontal(i, j) ||
            check_vertical(i, j) ||
            check_diag(i, j)

        return winner unless winner == nil
      end
    end

    winner
  end

  def check_horizontal(start_row, start_col)
    if start_col <= self.columns - 4 &&
        @state[start_row][start_col] != '' &&
            @state[start_row][start_col] == @state[start_row][start_col+1] &&
            @state[start_row][start_col] == @state[start_row][start_col+2] &&
            @state[start_row][start_col] == @state[start_row][start_col+3]

        puts "found match at row #{start_row}, col #{start_col}"
        return @state[start_row][start_col]
    end

    nil
  end

  def check_vertical(start_row, start_col)
    if start_row <= self.rows - 4 &&
        @state[start_row][start_col] != '' &&
        @state[start_row][start_col] == @state[start_row+1][start_col] &&
        @state[start_row][start_col] == @state[start_row+2][start_col] &&
        @state[start_row][start_col] == @state[start_row+3][start_col]

      puts "found match at row #{start_row}, col #{start_col}"
      return @state[start_row][start_col]
    end

    nil
  end

  def check_diag(start_row, start_col)
    if start_row <= self.rows - 4 &&
        start_col <= self.columns - 4

      # check lower-left - upper-right diag
      if @state[start_row][start_col] != '' &&
            @state[start_row][start_col] == @state[start_row+1][start_col+1] &&
            @state[start_row][start_col] == @state[start_row+2][start_col+2] &&
            @state[start_row][start_col] == @state[start_row+3][start_col+3]

        puts "found match at row #{start_row}, col #{start_col}"
        return @state[start_row][start_col]
      end

      # check upper-left - lower-right diag
      if @state[start_row+3][start_col] != '' &&
          @state[start_row+3][start_col] == @state[start_row+2][start_col+1] &&
          @state[start_row+3][start_col] == @state[start_row+1][start_col+2] &&
          @state[start_row+3][start_col] == @state[start_row][start_col+3]

        puts "found match at row #{start_row}, col #{start_col}"
        return @state[start_row+3][start_col]
      end
    end

    nil
  end

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