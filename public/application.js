var gameId = 0;
function populateGame(data) {
    if (data && data.state) {
        gameId = data.game_id;
        var table = $('table#gameTable').empty();
        data.state.forEach(function(rows) {
            var tr = $('<tr></tr>');
            var i = 0;
            rows.forEach(function(player) {
                var color = '';
                if (player) {
                    color = player == 1 ? 'red' : 'blue';
                }

                var td = $('<td data-column="' + i + '"><div class="' + color + '"></div></td>');
                tr.append(td);
                i++;
            });
            table.append(tr);
        });

        if (data.winner) {
            // delay a tiny bit so the board has a chance to draw before displaying the alert.
            setTimeout(function() {
                alert('Player ' + data.winner + ' won!');
            }, 100);
        }
    }
}

function populateGameList(id) {
    var gameList = $('#gameId');
    var newOption = '<option value="' + id + '">' + id + '</option>';
    gameList.append(newOption);
}

function prepareGame() {
    // load inital set of game ids
    $.ajax({
        type: "GET",
        url: '/game',
        success: function(ids) {
            ids.forEach(function(i) {
                populateGameList(i);
            });
        },
        dataType: 'json'
    });

    $('#getGameById').click(function() {
        $.ajax({
            type: "GET",
            url: '/game/' + $('#gameId > option:selected').val(),
            success: populateGame,
            dataType: 'json'
        });
    });

    $('#createNewGame').click(function() {
        var first_player = $('#firstPlayer > option:selected').val();
        var difficulty = $('#difficulty > option:selected').val();
        $.ajax({
            type: "POST",
            url: '/game',
            data: {
                first_player: first_player,
                difficulty: difficulty
            },
            success: function(data) {
                populateGame(data);
                populateGameList(data.game_id);
            },
            dataType: 'json'
        });
    });

    $('#gameTable').on('click', 'td', function() {
        var column = $(this).data('column');
        $.ajax({
            type: "POST",
            url: '/game/' + gameId + '/move',
            data: {
                column: column
            },
            success: populateGame,
            dataType: 'json'
        });
        console.log( $( this ).text() );
    });
}

$(document).ready(function() {
    prepareGame();
});
