"use strict";


//--------------------------------------------------------------------------------------------------
// Handeler for when the unssigned players panel is clicked that causes the player to be reassigned
// to the unssigned players team
//--------------------------------------------------------------------------------------------------
function OnLeaveTeamPressed()
{
	Game.PlayerJoinTeam( 5 ); // 5 == unassigned ( DOTA_TEAM_NOTEAM )
}

function OnJoinSlotPressed() {
	// Get the team and slot id asscociated with the team button that was pressed
	var teamID = $.GetContextPanel().GetAttributeInt("team_id", -1 );
	var slotID = $.GetContextPanel().GetAttributeInt("player_slot", -1);

	// Set the slot for the player
	var playerID = Players.GetLocalPlayer()
	GameEvents.SendCustomGameEventToServer( "update_player_slot", {"teamID": teamID, "slotID": slotID} )
	
	// Request to join the team of the button that was pressed
	Game.PlayerJoinTeam( teamID );
}

//--------------------------------------------------------------------------------------------------
// Update the contents of the player panel when the player information has been modified.
//--------------------------------------------------------------------------------------------------
function OnPlayerDetailsChanged()
{
    var playerId = $.GetContextPanel().GetAttributeInt("player_id", -1);

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;
	$( "#PlayerName" ).text = playerInfo.player_name;
	$( "#PlayerAvatar" ).steamid = playerInfo.player_steamid;

	$.GetContextPanel().SetHasClass( "player_is_local", playerInfo.player_is_local );
	$.GetContextPanel().SetHasClass( "player_has_host_privileges", playerInfo.player_has_host_privileges );
}


//--------------------------------------------------------------------------------------------------
// Entry point, update a player panel on creation and register for callbacks when the player details
// are changed.
//--------------------------------------------------------------------------------------------------
(function()
{
	OnPlayerDetailsChanged();
	$.RegisterForUnhandledEvent( "DOTAGame_PlayerDetailsChanged", OnPlayerDetailsChanged );
})();
