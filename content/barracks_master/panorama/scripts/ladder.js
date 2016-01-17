var url = 'http://barracksmaster.com/api?key=UbiGPvDoFn7z8isRV6h71Mrq3q3N93N1&resource=ladder'

function GetLadderData() {
    $.Msg("Getting Ladder data...")
    $.AsyncWebRequest( url, { type: 'GET', 
        success: function( data ) {
            var ladder = JSON.parse(data);
            $.Msg("Recieved "+ladder.length+" entries!")
            for (var i in ladder) {
                var rank = Number(i)+1
                var player = ladder[i]
                var name = player['steamdata']['personaname']
                var points = player['points']
                var num_matches = player['num_matches']
                var num_wins = player['num_wins']
                var winrate = Math.floor(Number(num_wins) / Number(num_matches) * 100)
                $.Msg("Rank #"+rank+": "+name+" | Points: "+points+" | Matches: "+num_matches+" | Wins: "+num_wins+" ("+winrate+"% Winrate)")
            };
        }
    })
}

(function () {    
    GetLadderData()
})();