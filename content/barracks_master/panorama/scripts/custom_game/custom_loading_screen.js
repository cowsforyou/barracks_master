var Root = $.GetContextPanel();

function Check_Loading(){
	var GameState = Game.GetState()

	/*
	// Update the background during custom game setup
	if (GameState == DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP){
		$.Msg("Changing Load Screen")
		var BG_Main = Root.FindChildTraverse("BG_Main")
		BG_Main.visible = false
		Root.SetHasClass("Done_Loading", true)

		// Hide tutorials
		var BM_Tutorials = Root.FindChildTraverse("BM_Tutorials")
		BM_Tutorials.visible = false
	}	
	else{
		$.Schedule(0.1, Check_Loading)
	}
	*/
}

(function () {
	Check_Loading();
})();
