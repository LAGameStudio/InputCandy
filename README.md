InputCandy by Lost Astronaut
============================

![GitHub Logo](/marketplace/InputCandyTeaser.png)

InputCandy focuses on providing input testing and customization for users
of PC and gamepad-friendly platforms (consoles).

It's that classic "control setup" panel system you are accustomed to seeing
in video games small and large, but for GameMaker.

For GMS 2.3.1+

Always get the latest version from https://github.com/LAGameStudio/InputCandy
See a bug?  Submit an issue here, or better yet, a Pull Request.

Project Roadmap
---------------

### Remaining Progress Toward 1.0.0

This table lists the remaining action items to be included in the 1.0.0 release.

| Feature | Progress |
|------|----------|
| SDL Mapping Confirmation Test | A feature is needed to assure that input control is not lost when a user activates an SDL mapping that ruins their device settings.  This panel should appear after a new mapping is selected.  |
| Capture Input Feature | Selection of input by capturing device input is a stretch goal that is not required for use now, but would be a value-added feature assisting players in setting up their input controls aside from the current list selection method.  This feature is also designed around allowing them to choose control axis in a two stage capture so they can program their thumbsticks (or other axis) as input. |
| Live Device Simulator | A special screen that allows users to test their devices and get visual feedback.  Originally it was intended to include features created for the Atari by computercoder on the Atari developer discord.  This set of features was to use light-up indicators on actual photographs of devices in an ever expanding list of device associated photographs, but the feature should probably be backscoped to just show buttons for 1.0.0 |
| Documentation | Tutorials on Github wiki, intro video, promo video, dev debrief/diary video planned for 1.0.0 |
| Tech Debt | Clean up ICUI such that users can reuse certain parts independently of the default workflow |

### Beyond 1.0.0

| Feature | Version Priority | Progress |
|---------|------------------|----------|
| Testing on other platforms | Any next version | We need volunteers publishing to XBox, PS4/5 and other platforms |
| Adding additional prefab UI components | 1.1.x and above | Adding additional more polished diagnostic tools that have their own Panel objects to be included in ICUI and as objects that can be included in your game ; adding a default "game menu" that can be styled ; a virtual keyboard for high score name entry, or any text entry, usable by controllers |
| Thumbstick virtualization | ? | Provide a way to define virtualized thumbsticks (combinations of axis) ... requires additional research and thinking about usefulness.  This feature has a first step in the planned capture input feature |
| Expanding Live Device Silmulator | 1.5.x and above | Expanding the Live Device simulator to support common console input controls (XInput, PS3, SNES/iBuffalo), STEAM Controller? As these are the most common controllers or are platform specific devices ; the goal is to use a visualization of the controller and "light up" or "arrow indicators" to show movements of the joystick, dpads, buttons etc, initially targetting: XBox, PS3/4/5, Atari VCS  |
| Allowing Keyboard to be exchanged for players other than player 1 | ? | Not sure if this is needed |
| Virtual on-screen joysticks | 1.8.x and above | Touch-sensor joysticks as a selectable device type for platforms that have touch screens ; there are other libraries that can handle this so this may be beyond scope |

Supporting InputCandy
---------------------

__If you download, use or just simply like this library, please star the above Repo, it helps. :)__     If you use this library in your
game, please add the provided Lost Astronaut and Image Candy logos to your startup screen if you wish
to give back a little credit to the creators of InputCandy.

Using InputCandy
----------------

You can use InputCandy in pieces or as a whole.

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

What is InputCandy Advanced Good For?
-------------------------------------

InputCandy "Advanced" is split into several components:
* InputCandy, the main ball of wax that handles the major features of designer-provided Actions, player-provided Settings, trackable Players (did they start yet? which controller are they using?), Devices (gamepads, keyboard, mouse), Signals (from devices) and a few other useful things.
* ICUI, the InputCandy User Interface, a style-able complete UI solution for selecting, configuring and simulating game control apparatus
* SDLDB, a library for reading, parsing and providing access to SDL GameController DB files (a recent one is included, or you may update it)

InputCandy comes with:
* A simple version (with simple diagnostics) for quick use
* A diagnostics screen that inspects game inputs
* A single room with multiple panels that shows off ICUI
* A test game
* A "Gamepad Keyboard" similar to the old nintendo games for highscore entry

InputCandy is good for:
* Multiplayer hot-seat games that use controllers
* Console games
* PC games with USB SDL-compatible PC game controllers and mouse/keyboard games
* Simplifying your work with control schemas
* Allowing players to rebind controls
* Allowing players to take advantage of the SDL Game Controller DB



Input Device Control Concept Diagram
------------------------------------
The following diagram illustrates the basic relationships of major concepts found in GameMaker, SDL and InputCandy.    It is not a complete architecture diagram, but is simple enough, yet complex enough, to illustrate how everything is connected in InputCandy.  

[![](https://mermaid.ink/img/eyJjb2RlIjoic3RhdGVEaWFncmFtLXYyXG4gICBbKl0gLS0-IFNETF9zbG90IDogKFVTQiBEZXZpY2UpXG4gICBbKl0gLS0-IE1vdXNlXG4gICBNb3VzZSAtLT4gU2lnbmFsIDogKG1vdXNlIHN0YXRlcylcbiAgIFsqXSAtLT4gS2V5Ym9hcmRcbiAgIEtleWJvYXJkIC0tPiBTaWduYWwgOiAoa2V5cylcbiAgIFsqXSAtLT4gR2FtZXBhZFxuICAgR2FtZXBhZCAtLT4gRGV2aWNlU3RhdGVcbiAgIERldmljZVN0YXRlIC0tPiBEcGFkXG4gICBEZXZpY2VTdGF0ZSAtLT4gQnV0dG9uXG4gICBEZXZpY2VTdGF0ZSAtLT4gQXhpc1xuICAgRGV2aWNlU3RhdGUgLS0-IEhhdFxuICAgQXhpcyAtLT4gU2lnbmFsXG4gICBTRExfc2xvdFxuICAgU0RMX3Nsb3QgLS0-IERldmljZVxuICAgU0RMX1JlbWFwcGluZyAtLT4gRGV2aWNlU3RhdGVcbiAgIFNETF9HYW1lY29udHJvbGxlcl9EQiAtLT4gU0RMX1JlbWFwcGluZyBcbiAgIFBsYXllciAtLT4gRGV2aWNlXG4gICBQbGF5ZXIgLS0-IFBsYXllcnNcbiAgIERldmljZSAtLT4gRGV2aWNlc1xuICAgRGV2aWNlU3RhdGUgLS0-IFRodW1ic3RpY2tcbiAgIFRodW1ic3RpY2sgLS0-IEF4aXMgOiBIXG4gICBUaHVtYnN0aWNrIC0tPiBBeGlzIDogVlxuICAgRHBhZCAtLT4gU2lnbmFsXG4gICBIYXQgLS0-IFNpZ25hbFxuICAgU2lnbmFsIC0tPiBTaWduYWxzXG4gICBCdXR0b24gLS0-IFNpZ25hbFxuICAgUGxheWVyIC0tPiBTZXR0aW5nXG4gICBTZXR0aW5nIC0tPiBTZXR0aW5nc1xuICAgQmluZGluZyAtLT4gQmluZGluZ3NcbiAgIFNpZ25hbCAtLT4gQmluZGluZyA6IGljX2NvZGVcbiAgIEJpbmRpbmdzIC0tPiBTZXR0aW5nXG4gICBCaW5kaW5nIC0tPiBBY3Rpb25cbiAgIFNpZ25hbHMgLS0-IEJpbmRpbmcgXG4gICBTaWduYWxzIC0tPiBBY3Rpb24gOiAobWF0Y2hpbmcgYWN0aW9uIGRlZmF1bHQpXG4gICBTaWduYWwgLS0-IEFjdGlvbiA6IGljX2NvZGVcbiAgIEFjdGlvbiAtLT4gQWN0aW9uc1xuICAgQWN0aW9uIC0tPiBCZWhhdmlvciA6IChpbiB0aGUgZ2FtZSlcbiAgIEJlaGF2aW9yIC0tPiBbKl0gOiAoR2FtZXBsYXkpIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic3RhdGVEaWFncmFtLXYyXG4gICBbKl0gLS0-IFNETF9zbG90IDogKFVTQiBEZXZpY2UpXG4gICBbKl0gLS0-IE1vdXNlXG4gICBNb3VzZSAtLT4gU2lnbmFsIDogKG1vdXNlIHN0YXRlcylcbiAgIFsqXSAtLT4gS2V5Ym9hcmRcbiAgIEtleWJvYXJkIC0tPiBTaWduYWwgOiAoa2V5cylcbiAgIFsqXSAtLT4gR2FtZXBhZFxuICAgR2FtZXBhZCAtLT4gRGV2aWNlU3RhdGVcbiAgIERldmljZVN0YXRlIC0tPiBEcGFkXG4gICBEZXZpY2VTdGF0ZSAtLT4gQnV0dG9uXG4gICBEZXZpY2VTdGF0ZSAtLT4gQXhpc1xuICAgRGV2aWNlU3RhdGUgLS0-IEhhdFxuICAgQXhpcyAtLT4gU2lnbmFsXG4gICBTRExfc2xvdFxuICAgU0RMX3Nsb3QgLS0-IERldmljZVxuICAgU0RMX1JlbWFwcGluZyAtLT4gRGV2aWNlU3RhdGVcbiAgIFNETF9HYW1lY29udHJvbGxlcl9EQiAtLT4gU0RMX1JlbWFwcGluZyBcbiAgIFBsYXllciAtLT4gRGV2aWNlXG4gICBQbGF5ZXIgLS0-IFBsYXllcnNcbiAgIERldmljZSAtLT4gRGV2aWNlc1xuICAgRGV2aWNlU3RhdGUgLS0-IFRodW1ic3RpY2tcbiAgIFRodW1ic3RpY2sgLS0-IEF4aXMgOiBIXG4gICBUaHVtYnN0aWNrIC0tPiBBeGlzIDogVlxuICAgRHBhZCAtLT4gU2lnbmFsXG4gICBIYXQgLS0-IFNpZ25hbFxuICAgU2lnbmFsIC0tPiBTaWduYWxzXG4gICBCdXR0b24gLS0-IFNpZ25hbFxuICAgUGxheWVyIC0tPiBTZXR0aW5nXG4gICBTZXR0aW5nIC0tPiBTZXR0aW5nc1xuICAgQmluZGluZyAtLT4gQmluZGluZ3NcbiAgIFNpZ25hbCAtLT4gQmluZGluZyA6IGljX2NvZGVcbiAgIEJpbmRpbmdzIC0tPiBTZXR0aW5nXG4gICBCaW5kaW5nIC0tPiBBY3Rpb25cbiAgIFNpZ25hbHMgLS0-IEJpbmRpbmcgXG4gICBTaWduYWxzIC0tPiBBY3Rpb24gOiAobWF0Y2hpbmcgYWN0aW9uIGRlZmF1bHQpXG4gICBTaWduYWwgLS0-IEFjdGlvbiA6IGljX2NvZGVcbiAgIEFjdGlvbiAtLT4gQWN0aW9uc1xuICAgQWN0aW9uIC0tPiBCZWhhdmlvciA6IChpbiB0aGUgZ2FtZSlcbiAgIEJlaGF2aW9yIC0tPiBbKl0gOiAoR2FtZXBsYXkpIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)

__The bottom of this chart (above), the nodes labeled Actions, Settings, Players, are the exposed surface of InputCandy that you, as a game developer, can choose to limit yourself to when implementing InputCandy as your control layer.  You create Actions, in turn you attempt to match them, and you choose when to go about the activation and deactivation of Players.  If you use the packaged ICUI helpers, then players create Settings (and bindings) as needed, and can access the SDLDB if you load that component.__

__By matching "actions", players can influence the behavior of the game, which is "fun" for the player.  A very dry way to explain user experience, but this is the gist of it.__


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

InputCandy's default settings panels for your games can be accessed directly or by calling the base panel.  This allows you to divide up the UI as you desire.  The UI also smartly turns off features when they have no value.   You'll never see a menu with one option, for example.

The default panels that are all interconnected are as follows:

* Picking a player-device association that shows "best guess" image of your joystick or gamepad
* Player-device menu (basic device info includes access to other sub-panels and options like choose your SDL DB string)
* "Binding and re-binding the input" panel, which includes load/save bindings options
* Gamepad simulator (TODO)


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
	- ATARI VCS Classic Controller (not in a special mode)
	- ATARI VCS Modern Controller (not in a special mode)
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

At some point we'll test on Xbox.  Right now it is mainly tested on PCs.  Volunteer to test for us!  File an Issue after you do so.


Planned Improvements
--------------------

- Complete UI
- Bindings / Settings / Save-and-load
- Advanced vibration options
- Virtual thumbstick "axis couplers" for axis support other than just gp_axis_l and gp_axis_h
- Networking support to transmit controller signals across the network


See the Notes > Note1.txt that is included in the project for more information on how to use this library.

