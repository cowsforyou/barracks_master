var Root = $.GetContextPanel()

function SetupLadderPlayer() {
    $('#AvatarImage').steamid = Root.steamid
    $('#LadderRank').text = Root.rankText
    $('#LadderName').text = Root.rankName
}

(function () {    
    SetupLadderPlayer()
})();