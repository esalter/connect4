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
    }
}

function prepareGame() {
    $('#getGameById').click(function() {
        $.ajax({
            type: "GET",
            url: '/game/' + $('#gameId').val(),
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
            success: populateGame,
            dataType: 'json'
        });
    });

    $('#gameTable').on('click', 'td', function() {
        console.log('here')
        var column = $(this).data('column');
        console.log(column);
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
