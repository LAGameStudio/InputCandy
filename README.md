InputCandy by Lost Astronaut
============================

For GMS 2.3.1+

Always get the latest version from https://github.com/LAGameStudio/InputCandy

If you like this library, please star the above Repo, it helps. :)     If you use this library in your
game, please add the provided Lost Astronaut and Image Candy logos to your startup screen if you wish
to give back a little credit to the creators of InputCandy.

InputCandy focuses on PC and gamepad-friendly platforms.  

It currently does not handle multitouch, screen reorientation,

InputCandy makes it easier to use input in GameMaker and does all of the "settings" and "selection"
for you, so you can easily import these features into other projects.  It was first written by LostAstronaut.com
for use with their games.  

It's important to note that this is for detecting momentary actions, not for detecting textual input ("typing").
It treats mice, keyboard and gamepad input as "button states"

InputCandy has two modes:

- NES-style simple mode, which works on a variety of devices and requires no set up but has a limited number of inputs,
  and works with certain assumptions

To access Simple mode, see the script InputCandySimple included in the package.  It's one function, so you don't have
to import all the other stuff.

- Advanced, verbose player-configured mode which allows for a lot of freedom but requires setup by the player

A Notes file contains Advanced mode information.  You want to use this is if you want a wider support for the
gamepad, and the ability to allow players to set their own control schemes.



Advanced: Verbose Player-Configured, Hardware-Normalized
========================================================

Hardware Testing Notes
----------------------

Advanced features of the library have been tested on a windows PC with the following devices attached:

	- Retrolink N64 Style Classic Controller for PC ($3.99)
	- X-Box 360 Wired USB Red Controller ($12.95) 
		- Stick-press did not register on right stick
		- Stick-press on left stick only worked when stick was slightly up-left
		- Supported vibration
	- LUXMO SNES Wired USB Controller for PC ($7.99)
	- Tomee USB Controller for PC/PS3 (PS3-style controller) ($19.99)
		- Both stick-presses registered properly
		- Triggers registered as shoulders and shoulders registered as triggers
	- Mouse, Keyboard

Note that initial testing did not use any SDL remapping.

I personally recommend the Tomee USB Controller (PS3-style) for anyone looking to get a nice controller,
though other brands of the same style (PS3) may be just as good and you can get them in 2.4Ghz and other
forms of wireless (Bluetooth and others).  This stick offered the most options and was easy to use,
had good tactile feedback and some versions of the PS3 for PC support rumble vibration.  The one I had
didn't.

Buttons labeled by InputCandy (and GameMaker) don't always match, for example: 
"A" (gp_face1) may not be labeled as such on any controller. 
The Retrolink N64-style controller makes A one of the yellow arrow buttons.  SNES-style controller may
label its button "X" to "A"

Feature List
------------

 - Organizes devices, states, and signals into structures in memory for quick access
 - Assigns devices by player
 - Normalizes buttons, keys and mouse clicks as "signals"
 - Provides an "Action" dictionary method to decouple controller signals from game actions
 - Provides diagnostic tools (rm_InputCandy_diagnostic_test)
 - Timed impulses for handling vibration effects
 - Provides a controller setup room that can be styled for your game (rm_InputCandy_settings)
 - Provides a player selection room that can be repurposed for your game (rm_InputCandy_player_selection)
	 - Allows players to assign who uses what controller
	 - Allows players to reprogram the controls from a default suggested setup
	 - Allow players to save and load controller schemes easily
	 - Allows players to access SDL controller database remappers.  Can also "grab from web" latest DB	 
 - Simple network control information transmission (TODO)

Support Table
-------------

The following table illustrates support level for each device type by the InputCandy framework.

Windows PC    Keyboard, Mouse, Gamepads supported in InputCandy for 1-X players, no touch support: use GameMaker to support
Linux PC      Keyboard, Mouse, Gamepads supported in InputCandy for 1-X players, no touch support: use GameMaker to support
Mac			  Support similar to Linux and Windows, needs further testing and corner cases
Apple TV	  Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
iOS           Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
Android       Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
Xbox          Untested, Gamepads supported
Sony PS4/5    Untested, Gamepads supported

In the above table, I'm trying to illustrate that, if you are making a single player game for a touch device, this
probably isn't the library for you.  If you want to support multiple controllers and user-defined control bindings,
and you want to also support the keyboard and mouse, this library is probably for you.

As an alternative, there are many on GitHub.
You may like https://github.com/JujuAdams/input/ which purports to be "Comprehensive cross-platform input for GameMaker Studio 2.3.0"

InputCandy's default settings panels for your games:

The more verbose way to use InputCandy is to include the o_InputCandy_settings and o_InputCandy_player_select
objects into their respective "rooms", to allow players to set up their experience, then use the monolithic
InputCandy interface struct (acquired with New_InputCandy()) to programattically test for actions,
connects, disconnects.

Integration with your Game
--------------------------

Instead of using GameMaker's interface checkers, use InputCandy instead.  Instead of using GameMaker's events
for mouse/keyboard, use InputCandy in the Step events, and in other special places.

Design Diagram
--------------

InputCandy is an exhaustive works-out-of-the-box way to handle input from Mouse, Keyboard and Controllers.
					
	Game			
	  |				
 +---------+                +----------+                         +------------------+
 | Actions |----Checking--->| Profile  |<------ Storing State----| Hardware Polling |
 +---------+                +----------+                 ^       +------------------+
                             /                           |
							/			    Hardware Compatibility
			 Stored/Loaded Into				     Rewiring
                          / 
                  +----------+    +------------+
                  | Settings |<---{ Per player }
                  +----------+    +------------+

You can modify it at every level.

General workflow:

Poller detects types of interface options and organizes them into 1...n
Saves Poll state into loaded profiles
Based on how you set up your game's actions, you can request per-action-per-player

In the above diagram, "Remappable Storing State" refers to the fact that there may be some oddities
with what, for example, "gamemaker" claims to be a controller's dpadup and what the actual controller
registers as dpadup, depending on the hardware.

Actions are input conditions tested for in Step Event that come in the flavors:
 "Pressed",
 "Held" ( with frame counter )
 "Released"

In some other input libraries these are also referred to as "Verbs", regardless of what it may be called,
it is a detected action on the controller that is translated by code to mean something in the game.

Actions are "hard wired" -- they cannot be changed by players, only by the designer/programmer.

Settings are device mappings to actions.  They are saved to disk and can be loaded in to a player's profile.
Additionally, the player can choose an SDL Mapping for a specific controller.  If they don't have one, it
defaults to the GameMaker defaults.  You can override this by changing the default SDL_Mapping variable.

Remappings are "hard coded" special filters that normalize hardware signals on third party devices.


Useful configuration panels:

Create a blank room in your game and called it whatever you like.  Load the o_InputCandy_settings object
into the room and it becomes the room that lets a player map Actions to Controller Manipulations.
Feel free to modify this object as you see fit.

There is also the o_InputCandy_player_select object.  Create a blank room and place it into the room and
it will transform that room into a "Player Select" screen.  This allows players to set up which controller
means which player, based on the currently connected controllers.  It also allows individual players
to save and load individual controller settings.


Hot swapping:

In the case of "I pulled the plug" or "I plugged something in", there isn't a reliable way to know
which player is using what controller because the IDs are not gauranteed by some systems.  InputCandy
does its best to maintain order in the system by holding empty the last removed controller's slot in
a virtual slot system, but even this isn't foolproof.  You can turn this feature off which lets InputCandy
simply remap controllers in order of detection, for slightly different behavior.

InputCandy also attempts to generate events like "Player Disconnected" or "Player Connected" or "Player Pressed Start"


Network: (TODO, Not yet available)

InputCandy provides basic network transmission functionality for reading actions from and writing actions
to with remote peers.  Since network is a very closely knit layer, you may look at these functions and
learn from them, then reimplement them in the most appropriate way, or in an entirely different way,
that works for your game, but out of the box it will allow you to do basic networking for low numbers
of players with limited sophistication.


Manifest
--------

Objects:


Rooms:


Script Files:


Sprites:




Planned Improvements
--------------------

- ATARI Controller remapping support, including Atari Classic Controller with "Twist"
- Networking support to transmit controller signals across the network

