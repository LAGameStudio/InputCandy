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

Supporting InputCandy
---------------------

__If you download, use, or just simply like this library, please star the above Repo, it helps. :)__     If you use this library in your
game, please add the provided Lost Astronaut and Image Candy logos to your startup screen if you wish
to give back a little credit to the creators of InputCandy.

Likewise, we'd love to showcase any game you make with InputCandy here on this page, or in a file included with future versions of InputCandy, so please open an "Issue" and announce your game when it's available for others to play, and we'll include it.

Understanding the Situation
---------------------------

InputCandy is good for the following things:

1) Provides a quick way of supporting most controllers (mouse, keyboard, and broadly implemented gamepad support) for your game menus.  Use InputCandySimple, or the MenuControls example for cross-platform VCS, PC and Linux support (below)
2) Provides a way for PC games to permit full Keyboard and Mouse customization.  Use ICUI.
3) Provides a diagnostic feature useful on multiple platforms to troubleshoot what values are actually coming from a controller when you physically move it.   Use rm_InputCandy_diagnostics
4) For local multiplayer ("couch" coop etc), InputCandy provides a way for users to select which player uses which controller.
5) Adapting to changing configurations
6) Remembering previous configurations
7) Provide a controller and mouse-friendly UI for customizing controls (ICUI)
8) Provide a way for users to see what their controllers are doing, and to test control schemes (ICUI's Test on Simulator)

However, in first writing and later using InputCandy, SDL and GameMaker, I can tell you the following nuggets of wisdom:

1) There is no reliable way to detect most controllers, including the most common ones like XBOX and PS4.  This is because no one uses the GUID properly and third-party companies fake their GUID information or the GUID information returned to GameMaker is unreliable and differs per platform.  The "Gamepad Description" is also not reliable.
2) Because there is no reliable way to detect most controllers, use of the SDLDB should be done so only in specific situations and is generally not recommended.  It certainly cannot be automagically applied to detected gamepads without user confirmation and one of those "Reverting in 15 seconds..." screens like you see in the Windows desktop when you change resolutions.
3) Because there is no reliable way to detect most controllers, you may have to resort to checking "number of buttons, hats and axis" in specific cases which can result in false positives.
4) See [Issue #2](https://github.com/LAGameStudio/InputCandy/issues/2)

Example Implementation
----------------------

In my game, Apolune: Through the Wormhole, InputCandy is used as a fallback, and before I implemented anything to do with InputCandy, I identified requirements:

1) The game targets PCs running Windows OR Linux, OR the VCS Console.
2) It would support a maximum of 8 players in local multiplayer.
3) The year of development is 2023, so it should support sane, contemporary controller default profiles without players having to use InputCandy at all.  Those default profiles were determined by the target platforms.  For Steam, the default would be supporting an XBOX controller, since this works well with the SteamDeck, is the most commonly used contemporary PC gamepad, and is most readily supported by GameMaker's default gamepad values.  For Linux, I am aware that the axis values are centered on `0.5,0.5` not `0.0,0.0` as it is on Windows.  The values range (on Linux) from 0 to 1, while on Windows they go from -1 to -1.  Finally, I was targeting the Atari VCS Console, which has two possible native controllers, the VCS Classic and the VCS Modern.
4) I still wanted the option for players to be able to fully customize other USB controllers if they so choose.
5) It would allow connect and disconnect (hot swapping) of controllers.  _Allow_ meaning it will not _crash_.

Where InputCandy shines is not in the ability to detect controller manufacturers, but rather to detect if they are connected, and to assign them to players and remember that setting.  It also works well when adjusting if a player has disconnected a controller during gameplay.

In point 2 above, I'm talking about profiles.  What I mean is, specific implementations selectable by the player. While [Issue #4](https://github.com/LAGameStudio/InputCandy/issues/4) suggests InputCandy provide a formal way of handling this, as it stands in <1.0.0 versions, it is left up to you, the game developer, to handle this because it is really specific to what you are trying to accomplish, ie. what platforms and expectations you have of your user audience.

For example, I chose to support the XBOX Series X/S controller.  It is wise to also support the PS4 Dual Shock controller.  In 2023, these are the most likely controllers for the PC, not because the game is going to come out on those consoles.   Additionally, I targeted 1 other platform, the Atari VCS Console, so I have support built in for the VCS Modern and the VCS Classic.

In my game controller menus, before it even reaches InputCandy, each of the 8 players has a default profile appropriate to the build platform.  For Steam builds, it chooses XBOX, and for the VCS it chooses the VCS.  Users then have the option of changing the profile to VCS (if they are using it on the VCS or on the PC with VCS hardware), XBOX (if they are using XBOX controllers on the VCS or on the PC), and PS4 (if they are using the PS4 controller), or CUSTOM, which is the InputCandy actions.   Note that on the PC, CUSTOM is the default setting for Player 1 when no gamepads are selected, because they must not have a gamepad and need to use InputCandy to handle the keyboard actions.

InputCandy's "assign device to player" ICUI panel is used to allow for specific assignments.  Each player has his/her own profile choice (VCS, XBOX, PS4 or CUSTOM).  I then wrote a series of functions wrapped around various actions.  When these functions are called, for example, `CheckFireButtonForPlayer(player_number)`, it checks my game's settings to see which of the profiles has been chosen for the player.  These settings are stored and handled separately from InputCandy's settings.

If CUSTOM is chosen, IC_Match is called, if XBOX, VCS or PS4 is chosen, it calls specific GML functions that will handle those activities.  For Apolune: Through the Wormhole, the game is a top-down shooter, so it has the following:

- Primary (true if fire button held)
- Secondary (true if fire button 2 is held)
- Tertiary (true if fire button 3 is held)
- AimLeft (usually a left shoulder, aims the turret on the ship)
- AimRight (usually a right shoulder, aims the turret on the ship)
- Move (a combination of sticks, hats, and d-pads, depending on which gamepad or joystick)
- Menu (the "open menu" button, or the "pause" button, usually a burger, can also be "Select")
- Back (a general "cancel" button, or "back" on some gamepads)

For each of these functions, I check against the player's game settings.  Here's an example for the CheckMenu function:
```javascript
function CheckMenuButtonForPlayer(pn) {
	var hand=GetPlayerControllerProfile(pn);
	if ( hand == false ) return false;
	var dv=hand.slot_id;
	if ( hand.slot_id != none ) {
		if ( isPlayerUsingVCSControls(pn) ) {
			if ( isPlayerUsingVCSClassic(pn) ) {
				return gamepad_button_check_released(dv,gp_face4);
			} else { // VCS Modern
				return gamepad_button_check_released(dv,gp_shoulderrb);
			}
		} else if ( isPlayerUsingXBOXControls(pn) ) {
			return gamepad_button_check_released(dv,gp_start);
		} else if ( isPlayerUsingPS4Controls(pn) ) {
			return gamepad_button_check_released(dv,gp_start);
		} else if ( isPlayerUsingInputCandy(pn) ) { // "CUSTOM"
			return IC_Match(pn,global.game_actions.menu.index);
		}
	} else if ( pn-1 == __INPUTCANDY.player_using_keyboard_mouse ) { 
		return IC_Match(pn,global.game_actions.menu.index);
	}
}
```

The way I went about figuring out how to program the above is by testing each controller on each platform using InputCandy's `rm_InputCandy_diagnostics`, and then writing a special case for each scenario that needed one.

MenuControls
------------

You need a generic, broadly usable, keyboard-friendly, and game-controller-friendly way of navigating menus before the player is asked a single configuration question.  This is the code I use in Apolune: Through the Wormhole to do this.  It is used on all cutscenes, help panels, game menus, and the main menu.  It has the ability to guess which player is doing the "accept" action.  It also tries to indicate if a VCS controller is present.  The MenuControls struct will return "release" signals for "left", "right", "up", "down", "back", "accept", and "cancel" - and you can also access globally the previous state via `global.Menucontrols_old_results` if you absolutely need to.

This code is built on top of InputCandySimple.  It supports VCS, PC games and can be adapted to other consoles.  This code is an example of the code used in Apolune: Through the Wormhole, and allows users to navigate game menus when the game first starts up.  Using this they can navigate to a menu option that leads to the customization panels available in ICUI.

1) Create an object o_MenuControls.
2) In o_MenuControls:Create, call Init_MenuControls()
3) In o_MenuControls:BeginStep, call MenuControls_top_of_frame()
4) In o_MenuControls:PostDraw, call MenuControls_end_of_frame()
5) Include o_MenuControls in any room that will serve as your game menu, and optionally during any cut-scene movie or help screen.
6) In any object that controls your menus, cut-scenes or help panel, access in a Step by calling var controls=MenuControls();  
7) Create a script called "MenuControls" and paste in the following:

```python

#macro MenuControls_defaultresults  { left: false, right: false, up: false, down: false, accept: false, cancel: false, back: false, initiator: none, key_or_mouse: false, VCS: { moderns: [], classics: [], modern: false, classic: false } }
function MenuControls() {
	return global.MenuControls_final_results;
}

function Init_MenuControls() {
	global.ic_simple_controls=InputCandySimple();
	global.MenuControls_old_results=MenuControls_defaultresults;
	global.MenuControls_results=MenuControls_defaultresults;
	global.MenuControls_final_results=MenuControls_defaultresults;
	global.MenuControls_selection_changed=false;
	global.MenuControls_last_selected_by_controls=true;
	global.MenuControls_frame_delay=0;
	global.MenuControls_initiator=none;
	global.MenuControls_mousepos = { mx: mouse_x, my: mouse_y };
}

function MenuControls_top_of_frame() {
	global.MenuControls_initiator=none;
	if ( global.MenuControls_frame_delay > 0 ) {
		global.MenuControls_frame_delay -= 1;
	}
	var controls=global.ic_simple_controls;
	var devices=controls.devices();
	var results=MenuControls_defaultresults;
	var newmousepos= { mx: mouse_x, my: mouse_y };
	if ( global.MenuControls_mousepos.mx != newmousepos.mx
	  or global.MenuControls_mousepos.my != newmousepos.my ) {
		  global.MenuControls_last_selected_by_controls = false;
	}
	global.MenuControls_mousepos=newmousepos;
	for ( var i=0; i<devices.count; i++ ) {
		var dv=i;
		var pn=i+1;
		var VCS_modern=( devices.gamepad_names[dv] == "Atari Game Controller" 
			|| devices.gamepad_names[dv] == "Atari Controller"
			|| devices.gamepad_names[dv] == "Atari VCS Modern Controller"
			|| devices.gamepad_guids[dv] == "03000000503200000210000000000000"
			|| devices.gamepad_guids[dv] == "03000000503200000210000011010000"
			|| devices.gamepad_guids[dv] == "05000000503200000210000000000000"
			|| devices.gamepad_guids[dv] == "05000000503200000210000045010000"
			|| devices.gamepad_guids[dv] == "05000000503200000210000046010000"
			|| devices.gamepad_guids[dv] == "05000000503200000210000047010000"
			||  ( os_type == os_linux && ( gamepad_button_count(dv) == 11 && gamepad_hat_count(dv) == 1 && gamepad_axis_count(dv) == 6 ) )
			);		
		var VCS_classic=( devices.gamepad_names[dv] == "Classic Controller"
			|| devices.gamepad_names[dv] == "Atari Classic Controller"
			|| devices.gamepad_guids[dv] == "03000000503200000110000000000000"
			|| devices.gamepad_guids[dv] == "03000000503200000110000011010000"
			|| devices.gamepad_guids[dv] == "05000000503200000110000000000000"
			|| devices.gamepad_guids[dv] == "05000000503200000110000044010000"
			|| devices.gamepad_guids[dv] == "05000000503200000110000046010000"
			|| ( gamepad_button_count(dv) == 5 && gamepad_hat_count(dv) == 1 && gamepad_axis_count(dv) == 1 ) );
		if ( VCS_classic ) {
			results.accept |= gamepad_button_check(dv,gp_face1); if ( results.accept and results.initiator == none ) results.initiator=pn;
			results.cancel |= gamepad_button_check(dv,gp_face2);
			results.back |= gamepad_button_check(dv,gp_face3);
			if ( gamepad_hat_value(dv,0)&1 ) {
				results.up |= true;
			}
			if ( gamepad_hat_value(dv,0)&2 ) {
				results.right |= true;
			}
			if ( gamepad_hat_value(dv,0)&4 ) {
				results.down |= true;
			}
			if ( gamepad_hat_value(dv,0)&8 ) {
				results.left |= true;
			}
		} else if ( VCS_modern ) {
			results.accept |= controls.A(pn);  if ( results.accept and results.initiator == none ) results.initiator=pn;
			results.cancel |= controls.B(pn);
			results.back   |= gamepad_button_check(dv,gp_select) or gamepad_button_check(dv,gp_start);
			if ( gamepad_hat_value(dv,0)&1 || (os_type == os_linux && (gamepad_axis_value(dv,1) < 0.4 || gamepad_axis_value(dv,4) < 0.4)) || (os_type == os_windows && (gamepad_axis_value(dv,1) < -0.5 || gamepad_axis_value(dv,4) > 0.5)) ) {
				results.up |= true;
			}
			if ( gamepad_hat_value(dv,0)&2 || (os_type == os_linux && (gamepad_axis_value(dv,0) > 0.6 || gamepad_axis_value(dv,3) > 0.6)) || (os_type == os_windows && (gamepad_axis_value(dv,0) > 0.5 || gamepad_axis_value(dv,3) > 0.5)) ) {
				results.right |= true;
			}
			if ( gamepad_hat_value(dv,0)&8 || (os_type == os_linux && (gamepad_axis_value(dv,0) < 0.4 || gamepad_axis_value(dv,3) < 0.4)) || (os_type == os_windows && (gamepad_axis_value(dv,0) < -0.5 || gamepad_axis_value(dv,3) < -0.5)) ) {
				results.left |= true;
			}
			if ( gamepad_hat_value(dv,0)&4 || (os_type == os_linux && (gamepad_axis_value(dv,1) > 0.6 || gamepad_axis_value(dv,4) > 0.6)) || (os_type == os_windows && (gamepad_axis_value(dv,1) > 0.5 || gamepad_axis_value(dv,4) < -0.5)) ) {
				results.down |= true;
			}
		} else {
			results.left   |= controls.left(pn);
			results.right  |= controls.right(pn);
			results.up     |= controls.up(pn);
			results.down   |= controls.down(pn);
			results.accept |= controls.A(pn); if ( results.accept and results.initiator == none ) results.initiator=pn;
			results.cancel |= controls.B(pn);
			results.back   |= gamepad_button_check(dv,gp_select) or keyboard_check(vk_escape);
		}
		results.VCS.moderns[i]=VCS_modern;
		results.VCS.classics[i]=VCS_classic;
		results.VCS.modern |= VCS_modern;
		results.VCS.classic |= VCS_classic;
	}
	var key_or_mouse_accept = keyboard_check(vk_enter) or keyboard_check(vk_control) or mouse_check_button(mb_left);
	results.accept |= key_or_mouse_accept; if ( key_or_mouse_accept ) results.initiator=1;
	results.cancel |= mouse_check_button(mb_right);
	results.back |= mouse_check_button(mb_middle);
	global.MenuControls_results=results;
	var old_results=global.MenuControls_old_results;
	var final_results=MenuControls_defaultresults;
	final_results.left   = !results.left   and old_results.left;
	final_results.right  = !results.right  and old_results.right;
	final_results.up     = !results.up     and old_results.up;
	final_results.down   = !results.down   and old_results.down;
	final_results.accept = !results.accept and old_results.accept;
	final_results.cancel = !results.cancel and old_results.cancel;
	final_results.back   = !results.back   and old_results.back;
	final_results.VCS    = results.VCS;
	final_results.key_or_mouse = key_or_mouse_accept;
	if ( final_results.accept ) global.MenuControls_initiator = old_results.initiator;
	global.MenuControls_final_results=final_results;	
}

function MenuControls_end_of_frame() {
	global.MenuControls_old_results=global.MenuControls_results;
	global.MenuControls_selection_changed=false;
	global.ANIMTIME += global.dt;
}
```

Using InputCandy
----------------

You can use InputCandy in pieces or as a whole.

It currently does not handle multitouch, screen reorientation, platform-specific scenarios beyond gamepads.

InputCandy makes it easier to use input in GameMaker and does all of the "settings" and "selection"
for you, so you can easily import these features into other projects.  It was first written by LostAstronaut.com
for use with their games.

It's important to note that this is for detecting momentary actions, not for detecting textual input ("typing").
It treats mice, keyboard and gamepad input as "button states"

InputCandy has two modes:

* NES-style __simple mode__, which works on a variety of devices and requires no setup but has a limited number of inputs,
  and works with certain assumptions

To access Simple mode, see the script InputCandySimple included in the package.  It's one function, so you don't have
to import all the other stuff.

* Advanced, verbose player-configured mode which allows for a lot of freedom but requires setup by the player

A Notes file contains Advanced mode information.  You want to use this if you want wider support for the
gamepad, and the ability to allow players to set their own control schemes.

What is InputCandy Advanced Good For?
-------------------------------------

InputCandy "Advanced" is split into several components:
* InputCandy, the main ball of wax that handles the major features of designer-provided Actions, player-provided Settings, trackable Players (did they start yet? which controller are they using?), Devices (gamepads, keyboard, mouse), Signals (from devices) and a few other useful things.
* ICUI, the InputCandy User Interface, a style-able complete UI solution for selecting, configuring and simulating game control apparatus
* SDLDB, a library for reading, parsing, and providing access to SDL GameController DB files (a recent one is included, or you may update it)

InputCandy comes with:
* A simple version (with simple diagnostics) for quick use
* A diagnostics screen that inspects game inputs
* A single room with multiple panels that shows off ICUI
* A test game
* A "Gamepad Keyboard" similar to the old Nintendo games for high-score entry

InputCandy is good for:
* Multiplayer hot-seat games that use controllers
* Console games
* PC games with USB SDL-compatible PC game controllers and mouse/keyboard games
* Simplifying your work with control schemas
* Allowing players to rebind controls
* Allowing players to take advantage of the SDL Game Controller DB

If you are going to use SDLDB, and you are testing with devices that don't map or have no DB entry, developers on the GameMaker Discord emphatically encourages you to submit a Pull Request to the SDL Gamecontroller Database at
https://github.com/gabomdq/SDL_GameControllerDB

Note that the use of the SDLDB is turned off by default as it may have undesired consequences and is not really necessary if the player is going to be permitted to remap input by use of device testing/capture or input selection.

Input Device Control Concept Diagram
------------------------------------
The following diagram illustrates the basic relationships of major concepts found in GameMaker, SDL, and InputCandy.    It is not a complete architecture diagram but is simple enough, yet complex enough, to illustrate how everything is connected in InputCandy.  

[![](https://mermaid.ink/img/eyJjb2RlIjoic3RhdGVEaWFncmFtLXYyXG4gICBbKl0gLS0-IFNETF9zbG90IDogKFVTQiBEZXZpY2UpXG4gICBbKl0gLS0-IE1vdXNlXG4gICBNb3VzZSAtLT4gU2lnbmFsIDogKG1vdXNlIHN0YXRlcylcbiAgIFsqXSAtLT4gS2V5Ym9hcmRcbiAgIEtleWJvYXJkIC0tPiBTaWduYWwgOiAoa2V5cylcbiAgIFsqXSAtLT4gR2FtZXBhZFxuICAgR2FtZXBhZCAtLT4gRGV2aWNlU3RhdGVcbiAgIERldmljZVN0YXRlIC0tPiBEcGFkXG4gICBEZXZpY2VTdGF0ZSAtLT4gQnV0dG9uXG4gICBEZXZpY2VTdGF0ZSAtLT4gQXhpc1xuICAgRGV2aWNlU3RhdGUgLS0-IEhhdFxuICAgQXhpcyAtLT4gU2lnbmFsXG4gICBTRExfc2xvdFxuICAgU0RMX3Nsb3QgLS0-IERldmljZVxuICAgU0RMX1JlbWFwcGluZyAtLT4gRGV2aWNlU3RhdGVcbiAgIFNETF9HYW1lY29udHJvbGxlcl9EQiAtLT4gU0RMX1JlbWFwcGluZyBcbiAgIFBsYXllciAtLT4gRGV2aWNlXG4gICBQbGF5ZXIgLS0-IFBsYXllcnNcbiAgIERldmljZSAtLT4gRGV2aWNlc1xuICAgRGV2aWNlU3RhdGUgLS0-IFRodW1ic3RpY2tcbiAgIFRodW1ic3RpY2sgLS0-IEF4aXMgOiBIXG4gICBUaHVtYnN0aWNrIC0tPiBBeGlzIDogVlxuICAgRHBhZCAtLT4gU2lnbmFsXG4gICBIYXQgLS0-IFNpZ25hbFxuICAgU2lnbmFsIC0tPiBTaWduYWxzXG4gICBCdXR0b24gLS0-IFNpZ25hbFxuICAgUGxheWVyIC0tPiBTZXR0aW5nXG4gICBTZXR0aW5nIC0tPiBTZXR0aW5nc1xuICAgQmluZGluZyAtLT4gQmluZGluZ3NcbiAgIFNpZ25hbCAtLT4gQmluZGluZyA6IGljX2NvZGVcbiAgIEJpbmRpbmdzIC0tPiBTZXR0aW5nXG4gICBCaW5kaW5nIC0tPiBBY3Rpb25cbiAgIFNpZ25hbHMgLS0-IEJpbmRpbmcgXG4gICBTaWduYWxzIC0tPiBBY3Rpb24gOiAobWF0Y2hpbmcgYWN0aW9uIGRlZmF1bHQpXG4gICBTaWduYWwgLS0-IEFjdGlvbiA6IGljX2NvZGVcbiAgIEFjdGlvbiAtLT4gQWN0aW9uc1xuICAgQWN0aW9uIC0tPiBCZWhhdmlvciA6IChpbiB0aGUgZ2FtZSlcbiAgIEJlaGF2aW9yIC0tPiBbKl0gOiAoR2FtZXBsYXkpIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)](https://mermaid-js.github.io/mermaid-live-editor/#/edit/eyJjb2RlIjoic3RhdGVEaWFncmFtLXYyXG4gICBbKl0gLS0-IFNETF9zbG90IDogKFVTQiBEZXZpY2UpXG4gICBbKl0gLS0-IE1vdXNlXG4gICBNb3VzZSAtLT4gU2lnbmFsIDogKG1vdXNlIHN0YXRlcylcbiAgIFsqXSAtLT4gS2V5Ym9hcmRcbiAgIEtleWJvYXJkIC0tPiBTaWduYWwgOiAoa2V5cylcbiAgIFsqXSAtLT4gR2FtZXBhZFxuICAgR2FtZXBhZCAtLT4gRGV2aWNlU3RhdGVcbiAgIERldmljZVN0YXRlIC0tPiBEcGFkXG4gICBEZXZpY2VTdGF0ZSAtLT4gQnV0dG9uXG4gICBEZXZpY2VTdGF0ZSAtLT4gQXhpc1xuICAgRGV2aWNlU3RhdGUgLS0-IEhhdFxuICAgQXhpcyAtLT4gU2lnbmFsXG4gICBTRExfc2xvdFxuICAgU0RMX3Nsb3QgLS0-IERldmljZVxuICAgU0RMX1JlbWFwcGluZyAtLT4gRGV2aWNlU3RhdGVcbiAgIFNETF9HYW1lY29udHJvbGxlcl9EQiAtLT4gU0RMX1JlbWFwcGluZyBcbiAgIFBsYXllciAtLT4gRGV2aWNlXG4gICBQbGF5ZXIgLS0-IFBsYXllcnNcbiAgIERldmljZSAtLT4gRGV2aWNlc1xuICAgRGV2aWNlU3RhdGUgLS0-IFRodW1ic3RpY2tcbiAgIFRodW1ic3RpY2sgLS0-IEF4aXMgOiBIXG4gICBUaHVtYnN0aWNrIC0tPiBBeGlzIDogVlxuICAgRHBhZCAtLT4gU2lnbmFsXG4gICBIYXQgLS0-IFNpZ25hbFxuICAgU2lnbmFsIC0tPiBTaWduYWxzXG4gICBCdXR0b24gLS0-IFNpZ25hbFxuICAgUGxheWVyIC0tPiBTZXR0aW5nXG4gICBTZXR0aW5nIC0tPiBTZXR0aW5nc1xuICAgQmluZGluZyAtLT4gQmluZGluZ3NcbiAgIFNpZ25hbCAtLT4gQmluZGluZyA6IGljX2NvZGVcbiAgIEJpbmRpbmdzIC0tPiBTZXR0aW5nXG4gICBCaW5kaW5nIC0tPiBBY3Rpb25cbiAgIFNpZ25hbHMgLS0-IEJpbmRpbmcgXG4gICBTaWduYWxzIC0tPiBBY3Rpb24gOiAobWF0Y2hpbmcgYWN0aW9uIGRlZmF1bHQpXG4gICBTaWduYWwgLS0-IEFjdGlvbiA6IGljX2NvZGVcbiAgIEFjdGlvbiAtLT4gQWN0aW9uc1xuICAgQWN0aW9uIC0tPiBCZWhhdmlvciA6IChpbiB0aGUgZ2FtZSlcbiAgIEJlaGF2aW9yIC0tPiBbKl0gOiAoR2FtZXBsYXkpIiwibWVybWFpZCI6eyJ0aGVtZSI6ImRlZmF1bHQifSwidXBkYXRlRWRpdG9yIjpmYWxzZX0)

__The bottom of this chart (above), the nodes labeled Actions, Settings, Players, are the exposed surface of InputCandy that you, as a game developer, can choose to limit yourself to when implementing InputCandy as your control layer.  You create Actions, in turn, you attempt to match them, and you choose when to go about the activation and deactivation of Players.  If you use the packaged ICUI helpers, then players create Settings (and bindings) as needed and can access the SDLDB if you load that component.__

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

The following table illustrates the support level for each device type by the InputCandy framework.

|Platform      |InputCandy's coverage
---------------|---------------------
|Windows PC    |Keyboard, Mouse, Gamepads supported in InputCandy for 1-X players, no touch support: use GameMaker to support
|Linux PC      |Keyboard, Mouse, Gamepads supported in InputCandy for 1-X players, no touch support: use GameMaker to support
|Mac           |Support similar to Linux and Windows, needs further testing and corner cases
|Apple TV      |Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
|iOS           |Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
|Android       |Some coverage, use GameMaker to handle touch and other special platform options, Gamepads supported
|Atari VCS     |See https://forum.yoyogames.com/index.php?threads/building-for-atari-vcs-ubuntu-18-04.96036/#post-591776 |
|Xbox          |Untested, Gamepads supported
|Sony PS4/5    |Untested, Gamepads supported
|HTML5 (Web)   |Untested, Gamepads supported

In the above table, I'm trying to illustrate that, if you are making a single-player game for a touch device, this
probably isn't the library for you.  If you want to support multiple controllers and user-defined control bindings,
and you want to also support the keyboard and mouse, this library is probably for you.

As an alternative, there are many on GitHub.
You may like https://github.com/JujuAdams/input/ which purports to be "Comprehensive cross-platform input for GameMaker Studio 2.3.0"

InputCandy's default settings panels for your games can be accessed directly or by calling the base panel.  This allows you to divide up the UI as you desire.  The UI also smartly turns off features when they have no value.   You'll never see a menu with one option, for example.

The default panels that are all interconnected are as follows:

* Picking a player-device association that shows the "best guess" image of your joystick or gamepad
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
   		- Cannot detect X button  
  	- Modern XBOX Controller (X or S series) ($49.95)
   		- Generally maps correctly to most GameMaker defaults
     		- Left trigger registers as "Buttons[10]" and has a range of 0.0 - 0.30 (fully pulled)
       		- Underneath micro buttons do not register (cannot read value)
	 	- Left/right switch control on LED illuminated did not register (cannot read value)
   		- Cannot detect X button
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


Project Roadmap
---------------

### Remaining Progress Toward 1.0.0

This table lists the remaining action items to be included in the 1.0.0 release.

| Feature | Progress |
|------|----------|
| Advanced vibration options | A system for time-based vibration events is planned |
| SDL Mapping Confirmation Test | A feature is needed to assure that input control is not lost when a user activates an SDL mapping that ruins their device settings.  This panel should appear after a new mapping is selected.  |
| Capture Input Feature | Selection of input by capturing device input is a stretch goal that is not required for use now, but would be a value-added feature assisting players in setting up their input controls aside from the current list selection method.  This feature is also designed around allowing them to choose control axis in a two stage capture so they can program their thumbsticks (or other axis) as input. |
| Live Device Simulator | A special screen that allows users to test their devices and get visual feedback.  Originally it was intended to include features created for the Atari by computercoder on the Atari developer discord.  This set of features was to use light-up indicators on actual photographs of devices in an ever-expanding list of device-associated photographs, but the feature should probably be backscoped to just show buttons for 1.0.0 |
| Documentation | Tutorials on Github wiki, intro video, promo video, dev debrief/diary video planned for 1.0.0 |
| Tech Debt | Clean up ICUI such that users can reuse certain parts independently of the default workflow |

### Beyond 1.0.0

| Feature | Version Priority | Progress |
|---------|------------------|----------|
| Testing on other platforms | Any next version | We need volunteers publishing to XBox, PS4/5 and other platforms |
| Adding additional prefab UI components | 1.1.x and above | Adding additional more polished diagnostic tools that have their own Panel objects to be included in ICUI and as objects that can be included in your game ; adding a default "game menu" that can be styled ; a virtual keyboard for high score name entry, or any text entry, usable by controllers |
| Thumbstick virtualization | ? | Provide a way to define virtualized thumbsticks (combinations of axis) ... requires additional research and thinking about usefulness.  This feature has a first step in the planned capture input feature; Virtual thumbstick "axis couplers" for axis support other than just gp_axis_l and gp_axis_h |
| Expanding Live Device Silmulator | 1.5.x and above | Expanding the Live Device simulator to support common console input controls (XInput, PS3, SNES/iBuffalo), STEAM Controller? As these are the most common controllers or are platform-specific devices ; the goal is to use a visualization of the controller and "light up" or "arrow indicators" to show movements of the joystick, d-pads, buttons, etc, initially targeting: XBox, PS3/4/5, Atari VCS  |
| Allowing Keyboard to be exchanged for players other than player 1 | ? | Not sure if this is needed |
| Virtual on-screen joysticks | 1.8.x and above | Touch-sensor joysticks as a selectable device type for platforms that have touch screens ; there are other libraries that can handle this so this may be beyond scope |
| Network Mirroring of Input | 2.x | This may end up being a different library or "extension" to InputCandy (Networking support to transmit controller signals across the network) |



See the Notes > Note1.txt that is included in the project for more information on how to use this library.

