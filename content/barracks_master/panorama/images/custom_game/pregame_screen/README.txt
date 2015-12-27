----- Pregame Screen Interactions -----

----- Refer to the series of images preview01, preview02 etc to see the design -----

1) Fonts used throughout is dota's default: Radiance. The title "BARRACKS MASTER" is Radiance-Bold.

2) There will be two maps in Barracks Master (duo map and quad map) the pregame screen should display a 2 player count per team for the duo and 4 player count per team for the quad.

3) Spectator team will always be 4 count regardless of the map.

4) The players should be placed automatically in the radiant/dire teams. They may choose to shuffle on their own.

5) Currently the slots corresponds to a specific spawn point and a specific hero in the game. However, with the present interface it always fills slot 1 first (Sven for Radiant and TB for Dire). If you're able to override that so players can choose slot 2 leaving slot 1 empty, then that is great. If unable, then follow the current system where slot 1 must be filled before slot 2 is allowed.

6) Currently, the colors are coded to specific heroes (e.g. Sven is blue, TB is red). You can find the codes at the bottom of spawner.lua. This is probably where you'll need to tweak to allow the choosing of different colors.

7) There should be 8 colors available (red, blue, cyan, purple, yellow, orange, green, pink). You can see how the dropdown should look like on preview05_duo_colordrop.png.

8) The colors should automatically be picked for them when they fill the empty slots (refer to preview06_2players.png). Clicking the color dropdown should only show the remaining available colors (no duplicates).

9) The hero background on the left should populate based on the hero chosen. The hero background should overlay the existing background at 30% opacity. Refer to preview03_duo_w_background.png.

10) The Updates, Image and Ladder backgrounds should be at 50% opacity.

11) The map preview and map name should correspond to the chosen map (either duo or quad). Note that the quad map is not created yet but please make provisions.

12) Likewise for the hero icons (the TA spam and veno spam on preview02_quad.png) - they have not been decided yet so those are placeholders.

12) I did not include the images for the chatbox, star icon, countdown timer and LOCK + START button as these are the default ones Valve is using.