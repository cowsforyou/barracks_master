var url = 'http://barracksmaster.herokuapp.com/top_10'

function GetLadderData() {
    $.Msg("Getting Ladder data...")
    $.AsyncWebRequest( url, { type: 'GET', 
        success: function( data ) {
            $.Msg("Success!")
            //var ladder = JSON.parse(data);
            $.Msg(data)
            /*$.Msg("Recieved "+ladder.length+" entries!")
            for (var i in ladder) {
                var player = ladder[i]
                var rank = player['rank']
                var name = player['username']
                var points = player['points']
                var steamID = player['steamID']
                $.Msg("Rank #"+rank+": "+name+" | Points: "+points)
                CreateLadderPlayer(rank, steamID, name)
            };*/
        }
    })
}

function CreateLadderPlayer(rank, steamid, name) {
    var parent = $('#LadderPlayerPanel')
    var playerPanel = $.CreatePanel("Panel", parent, name)
    playerPanel.steamid = steamid
    playerPanel.rankText = rank
    playerPanel.rankName = name
    playerPanel.BLoadLayout("file://{resources}/layout/custom_game/ladder_player.xml", false, false);
}

(function () {
    GetLadderData()
})();
