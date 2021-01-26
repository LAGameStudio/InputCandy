InputCandy by Lost Astronaut
============================

![GitHub Logo](/marketplace/InputCandyTeaser.png)

For GMS 2.3.1+

Always get the latest version from https://github.com/LAGameStudio/InputCandy
See a bug?  Submit an issue here, or better yet, a Pull Request.

If you like this library, please star the above Repo, it helps. :)     If you use this library in your
game, please add the provided Lost Astronaut and Image Candy logos to your startup screen if you wish
to give back a little credit to the creators of InputCandy.

InputCandy focuses on PC and gamepad-friendly platforms.

It currently does not handle multitouch, screen reorientation, platform specific scenarios beyond gamepads.

InputCandy makes it easier to use input in GameMaker and does all of the "settings" and "selection"
for you, so you can easily import these features into other projects.  It was first written by LostAstronaut.com
for use with their games.

It's important to note that this is for detecting momentary actions, not for detecting textual input ("typing").
It treats mice, keyboard and gamepad input as "button states"

InputCandy has two modes:

* NES-style __simple mode__, which works on a variety of devices and requires no set up but has a limited number of inputs,
  and works with certain assumptions

To access Simple mode, see the script InputCandySimple included in the package.  It's one function, so you don't have
to import all the other stuff.

* Advanced, verbose player-configured mode which allows for a lot of freedom but requires setup by the player

A Notes file contains Advanced mode information.  You want to use this is if you want a wider support for the
gamepad, and the ability to allow players to set their own control schemes.


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

|Platform      |InputCandy's coverage
---------------|---------------------
|Windows PC    |Keyboard, Mouse, Gamepads supported in InputCandy for 1-X players, no touch support: use GameMaker to support
|Linux PC      |Keyboard, Mouse, Gamepads supported in InputCandy for 1-X players, no touch support: use GameMaker to support
|Mac           |Support similar to Linux and Windows, needs further testing and corner cases
|Apple TV      |Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
|iOS           |Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
|Android       |Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
|Xbox          |Untested, Gamepads supported
|Sony PS4/5    |Untested, Gamepads supported
|HTML5 (Web)   |Untested, Gamepads supported

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

Planned Improvements
--------------------

- Complete UI
- Bindings / Settings / Save-and-load
- Networking support to transmit controller signals across the network


See the Notes > Note1.txt that is included in the project for more information on how to use this library.



Input Device Control Concept Diagram
------------------------------------
[![](https://mermaid.ink/img/eyJjb2RlIjoic3RhdGVEaWFncmFtLXYyXG4gICBbKl0gLS0-IFNETF9zbG90IDogKFVTQiBEZXZpY2UpXG4gICBbKl0gLS0-IE1vdXNlXG4gICBNb3VzZSAtLT4gU2lnbmFsIDogKG1vdXNlIHN0YXRlcylcbiAgIFsqXSAtLT4gS2V5Ym9hcmRcbiAgIEtleWJvYXJkIC0tPiBTaWduYWwgOiAoa2V5cylcbiAgIFsqXSAtLT4gR2FtZXBhZFxuICAgR2FtZXBhZCAtLT4gRGV2aWNlU3RhdGVcbiAgIERldmljZVN0YXRlIC0tPiBEcGFkXG4gICBEZXZpY2VTdGF0ZSAtLT4gQnV0dG9uXG4gICBEZXZpY2VTdGF0ZSAtLT4gQXhpc1xuICAgRGV2aWNlU3RhdGUgLS0-IEhhdFxuICAgQXhpcyAtLT4gU2lnbmFsXG4gICBTRExfc2xvdFxuICAgU0RMX3Nsb3QgLS0-IFNETFxuICAgU0RMX1JlbWFwcGluZyAtLT4gU0RMXG4gICBTREwgLS0-IERldmljZSA6IHNsb3RfaWRcbiAgIFNETF9HYW1lY29udHJvbGxlcl9EQiAtLT4gU0RMX1JlbWFwcGluZyBcbiAgIFBsYXllciAtLT4gRGV2aWNlIDogaW5kZXhcbiAgIFBsYXllciAtLT4gUGxheWVyc1xuICAgRGV2aWNlIC0tPiBEZXZpY2VzXG4gICBEZXZpY2VTdGF0ZSAtLT4gVGh1bWJzdGlja1xuICAgVGh1bWJzdGljayAtLT4gQXhpcyA6IEhcbiAgIFRodW1ic3RpY2sgLS0-IEF4aXMgOiBWXG4gICBEcGFkIC0tPiBTaWduYWxcbiAgIEhhdCAtLT4gU2lnbmFsXG4gICBTaWduYWwgLS0-IFNpZ25hbHNcbiAgIEJ1dHRvbiAtLT4gU2lnbmFsXG4gICBQbGF5ZXIgLS0-IFNldHRpbmdzXG4gICBCaW5kaW5nIC0tPiBCaW5kaW5nc1xuICAgU2lnbmFsIC0tPiBCaW5kaW5nIDogaWNfY29kZVxuICAgQmluZGluZ3MgLS0-IFNldHRpbmdzXG4gICBCaW5kaW5nIC0tPiBBY3Rpb25cbiAgIFNpZ25hbHMgLS0-IEJpbmRpbmcgXG4gICBTaWduYWxzIC0tPiBBY3Rpb24gOiAoZGVmYXVsdCBmcm9tIGFjdGlvbilcbiAgIFNpZ25hbCAtLT4gQWN0aW9uIDogaWNfY29kZVxuICAgQWN0aW9uIC0tPiBBY3Rpb25zXG4gICBBY3Rpb24gLS0-IEJlaGF2aW9yIDogKGluIHRoZSBnYW1lKVxuICAgQmVoYXZpb3IgLS0-IFsqXSA6IChHYW1lcGxheSkiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic3RhdGVEaWFncmFtLXYyXG4gICBbKl0gLS0-IFNETF9zbG90IDogKFVTQiBEZXZpY2UpXG4gICBbKl0gLS0-IE1vdXNlXG4gICBNb3VzZSAtLT4gU2lnbmFsIDogKG1vdXNlIHN0YXRlcylcbiAgIFsqXSAtLT4gS2V5Ym9hcmRcbiAgIEtleWJvYXJkIC0tPiBTaWduYWwgOiAoa2V5cylcbiAgIFsqXSAtLT4gR2FtZXBhZFxuICAgR2FtZXBhZCAtLT4gRGV2aWNlU3RhdGVcbiAgIERldmljZVN0YXRlIC0tPiBEcGFkXG4gICBEZXZpY2VTdGF0ZSAtLT4gQnV0dG9uXG4gICBEZXZpY2VTdGF0ZSAtLT4gQXhpc1xuICAgRGV2aWNlU3RhdGUgLS0-IEhhdFxuICAgQXhpcyAtLT4gU2lnbmFsXG4gICBTRExfc2xvdFxuICAgU0RMX3Nsb3QgLS0-IFNETFxuICAgU0RMX1JlbWFwcGluZyAtLT4gU0RMXG4gICBTREwgLS0-IERldmljZSA6IHNsb3RfaWRcbiAgIFNETF9HYW1lY29udHJvbGxlcl9EQiAtLT4gU0RMX1JlbWFwcGluZyBcbiAgIFBsYXllciAtLT4gRGV2aWNlIDogaW5kZXhcbiAgIFBsYXllciAtLT4gUGxheWVyc1xuICAgRGV2aWNlIC0tPiBEZXZpY2VzXG4gICBEZXZpY2VTdGF0ZSAtLT4gVGh1bWJzdGlja1xuICAgVGh1bWJzdGljayAtLT4gQXhpcyA6IEhcbiAgIFRodW1ic3RpY2sgLS0-IEF4aXMgOiBWXG4gICBEcGFkIC0tPiBTaWduYWxcbiAgIEhhdCAtLT4gU2lnbmFsXG4gICBTaWduYWwgLS0-IFNpZ25hbHNcbiAgIEJ1dHRvbiAtLT4gU2lnbmFsXG4gICBQbGF5ZXIgLS0-IFNldHRpbmdzXG4gICBCaW5kaW5nIC0tPiBCaW5kaW5nc1xuICAgU2lnbmFsIC0tPiBCaW5kaW5nIDogaWNfY29kZVxuICAgQmluZGluZ3MgLS0-IFNldHRpbmdzXG4gICBCaW5kaW5nIC0tPiBBY3Rpb25cbiAgIFNpZ25hbHMgLS0-IEJpbmRpbmcgXG4gICBTaWduYWxzIC0tPiBBY3Rpb24gOiAoZGVmYXVsdCBmcm9tIGFjdGlvbilcbiAgIFNpZ25hbCAtLT4gQWN0aW9uIDogaWNfY29kZVxuICAgQWN0aW9uIC0tPiBBY3Rpb25zXG4gICBBY3Rpb24gLS0-IEJlaGF2aW9yIDogKGluIHRoZSBnYW1lKVxuICAgQmVoYXZpb3IgLS0-IFsqXSA6IChHYW1lcGxheSkiLCJtZXJtYWlkIjp7InRoZW1lIjoiZGVmYXVsdCJ9LCJ1cGRhdGVFZGl0b3IiOmZhbHNlfQ)
