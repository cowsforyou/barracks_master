----- Ready Screen Interactions -----

1) I'm not sure if you're able to force a slot 2 selection if slot 1 is empty, so if the answer is yes, then players should be able to pick any slot they wish (e.g. they can pick TA immediately on Radiant). If that is not possible, then have the script auto push players to slot 1 so access to slot 2 is only possible if slot 1 is filled.

2) Players should be automatically assigned to the Radiant and Dire teams. Should they wish to swap around, they can do so on their own by moving to Unassigned or directly to the other team. Automatically assigning them to the Radiant/Dire should make it easier for noobs (as opposed to default assigning everyone to Unassigned).

3) There will be two different layouts (preview_duo and preview_quad will show you the preview). One is for the 2v2 map the other is for the 4v4 map.

4) The middle background should correspond to the hero selected by the player. If the player has selected unassigned, then it should revert to the default background.

5) The chat box width is the default width that Valve is using. If you're able to modify the width, then having it stretched to match the unassigned grey line width is ideal.

6) I did not include the minimap image since I am assuming you are going to draw that from the actual file. But the size I am using in the preview is 80% of the original tga file resolution.

7) Everyone will be by default given the red color on the ready screen. However, in the case of color duplicates, the AI should just assign the next available color to the 2nd player with the duplicate color. E.g. Slot 1 and 2 Radiant have red selected, then when the game starts, slot 1 will be given red and slot 2 be given blue.

8) The countdown timer is also the default one used by Valve currently so that image is not provided. The background for it however is provided (background_timer.png).

9) The additional heroes in the quad mode are not decided yet, so the TA and Veno icons are placeholders.

10) The LOCK + START button is also not provided - that is the default one Valve uses.

11) The updates background and host control backgrounds should be set to 50% opacity.

12) The hero backgrounds should all be set at 30% opacity.

13) The color picker is not coded on the game yet so you will have to help me do that to work with this Ready Screen. Everything else should be available and just needs a link up.

14) For the updates panel on the left, pull the text from addon_english.txt in the game/barracks_master/resource folder. It is under "bm_updates_text" - that is what I'm using currently for my loading screen.