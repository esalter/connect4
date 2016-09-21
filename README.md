Connect 4 Game
==============

A simple game that plays classic (7x6 grid) connect 4 with you.  

## API

POST /game Creates a new game.
  {
    "difficulty": "easy" // or "hard",
    "first": true // false to have the computer go first. The initial response will include the computer's first move.
  }

GET /game/{:id} Gets a game with the given id at its current state.
POST /game/move Creates a new move
  {
    "column": [1-7]  // only one column allowed.  Must not be full (6 tall is full) and it must be your turn.  The response will include the computer's move.
  }



Game state:
7x6 matrix of red/black tokens.  Red always goes first.

a "move" consists of dropping a token into a column.  Players must alternate turns.  The token must drop in columns [1,7].  The token cannot be dropped into a column that is full (6 tall).

A player wins when they manage to build a line of 4 of their tokens horizontally, vertically, or diagonally.
