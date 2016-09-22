function populateGame(data) {
    if (data) {
        var table = $('table#gameTable').empty();
        console.log(data);
        data.forEach(function(rows) {
            var tr = $('<tr></tr>');
            rows.forEach(function(column) {
               var td = $('<td>' + column + '</td>');
                tr.append(td);
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
}

$(document).ready(function() {
    prepareGame();
});
