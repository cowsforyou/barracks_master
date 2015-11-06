"use strict";

var g_ScoreboardHandle = null;
var nextPressActivatesScoreboard = true;

function SetFlyoutScoreboardVisible( bVisible )
{
	// bVisible is true when the button is pressed, false when released.
	// We want to turn the hold-down behavior into a toggle click, so only listen to button presses.
	// NOTE: This messes with the default behavior of clicking the UI button, so we should hide/replace it.
	if ( bVisible )
	{
		// and the next press will activate the scoreboard
		if (nextPressActivatesScoreboard)
		{
			// set values to true, and next press will deactivate
			ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, true );
			$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", true );			
			nextPressActivatesScoreboard = false
		}
		else
		{
			ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, false );
			$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", false );	
			nextPressActivatesScoreboard = true
		}
	}
}

// refresh the scoreboard every second when the custom event is called
function RefreshScoreboard()
{
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, !nextPressActivatesScoreboard );
}

(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_flyout_scoreboard_player.xml",
	};
	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );
	
	SetFlyoutScoreboardVisible( true );
	
	GameEvents.Subscribe( "RefreshScoreboard", RefreshScoreboard );
	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
