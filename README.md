Connect 4 Game
==============

A simple game that plays classic (7x6 grid) connect 4 with you.

## API

- **POST /game** - Creates a new game.
  - body:
````
  {
    "difficulty": "easy" // or "hard",
    "first_player": 1 // 2 to have the computer go first. The initial response will include the computer's first move.
  }
````
- **GET /game** - Gets a list of game ids in the system. You can load any game from its current state.
- **GET /game/{:id}** - Gets a game with the given id at its current state.
- **POST /game/{:id}/move** - Creates a new move for the given game.  The response includes the computer's move, so depending on the difficulty it will take some time to get a response.
  - body:
````
  {
    "column": [0-6]  // only one column allowed.  Must not be full (6 tall is full) and it must be your turn.  The response will include the computer's move.
  }
````


### Game state:
7x6 matrix of red/black tokens.  Red always goes first.

A "move" consists of dropping a token into a column.  Players must alternate turns.  The token must drop in columns [0,6].  The token cannot be dropped into a column that is full (6 tall).

A player wins when they manage to build a line of 4 of their tokens horizontally, vertically, or diagonally.

## INSTALL
````
bundle
rake db:migrate
rackup
````
Server is now running on localhost:9292

## TESTS
````
RACK_ENV=test rake db:migrate
rspec
````

## Things to do if I get time:
- Optimize.  Unfortunately the program is quite slow to calculate new moves.  I'm not sure if my algorithm is just poor or if it is mainly Ruby.  I am using the Minimax algorithm with alpha-beta pruning, however I'm sure there are ways I could speed up score calcs and optimize which part of the search tree to attempt first. Given more time I'd also likely rewrite it in a faster language.
- playback feature (fast backward, step back, step forward)
- undo (delete my last move, also the computer's last move)

## Acknowledgements

The minimax algorithm I used was heavily inspired from these implementations, adapted to Ruby.

- https://github.com/erikackermann/Connect-Four/blob/master/minimax.py
- https://gimu.org/connect-four-js/
