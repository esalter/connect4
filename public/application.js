function populateGame(data) {
    if (data) {
        var table = $('table#gameTable').empty();
        console.log(data);
        data.forEach(function(rows) {
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
        var checked = $('#goFirst').is(':checked');
        var difficulty = $('#difficulty > option:selected').text();
        $.ajax({
            type: "POST",
            url: '/game',
            data: {
                first: checked,
                difficulty: difficulty
            },
            success: populateGame,
            dataType: 'json'
        });
    });
    $('table#gameTable td').click(function(el) {
        var column = $(el).data('column');
        $.ajax({
            type: "POST",
            url: '/game/5/move',
            data: {
                column: column
            },
            success: populateGame,
            dataType: 'json'
        });
    })
}

$(document).ready(function() {
    prepareGame();
});
