function populateGame(data) {

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
        console.log(checked);
        console.log(difficulty);
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
