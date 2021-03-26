# Godot-Simple-FPS-Controller
A very simple and basic FPS controller for use in the godot game engine

# Usage

Download both the Kinematic_actor.gd script and the Kinematic_actor.tscn file into your godot project's directory, then drag and drop the Kinematic_actor.tscn node into your level scene and run.

##  Remapping controls

### Option 1 (Reccomended and most supported)

1. Click the ```Project``` tab at the top of the Godot editor and click ```Project Settings```
A window with additional dialog should open up.

2. Navigate to the ```Input Map``` tab and use the dialog box at the top of the page (labeled ```Action```) to type "move_forwards", then click the button at the far right of the dialog labeled ```Add``` to add the Action to the list of Actions. 
You should now see this action at the bottom of the list, you may need to scroll down 

3. Click the ```+``` symbol on the far right of the ```move_forwards``` column and select ```Key``` from the dropdown menu
A dialog labeled "Please Confirm" should pop up prompting you to press a key

4. Press a key in order to map it to that action
You should see that key appear just below the column along with a symbol, you may repeat step 3 if you wish to map ```move_forwards``` to more than one key

5. Repeat steps 2-4 with the following actions 
* ```move_backwards```
* ```move_left```
* ```move_right```

### Option 2 (quicker / less config, potentially more buggy)

1. Find ```kinematic_actor.tscn``` inside of the Godot FileSystem tab (by default this will be in the far-left corner) and double-click it to open the scene editor
2. Click the root node ```kinematic_actor``` and look for the ```Alternative Input Map``` variable exposed in the editor
3. Replace the ```move_forwards```, ```move_backwards```, ```move_left```, ```move_right``` with single character strings representing the keys on the keyboard you want to map the input to
