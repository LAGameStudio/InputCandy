/*

InputCandy for GMS 2.3.1+
Always get the latest version from https://github.com/LAGameStudio/InputCandy

See LICENSE for usage guidelines.

See Notes > Note1 for more information

*/

#macro __INPUTCANDY global.IC
#macro __IC __INPUTCANDY.interface
#macro __ICI __INPUTCANDY.internal


// 1. Initialize the "Advanced mode" with the following function call in a Room Creation or during initial game startup.
function Init_InputCandy_Advanced() { __Private_Init_InputCandy(); }

/*
  InputCandy's advanced mode is relatively easy to use.
  
  After initialization, see documentation on usage for how to set up these things:
  
  1. Define your game actions and any default signal bindings.
  
  2. Place action checks throughout your game to "tie in" the game.
  
  3. Provide access to the InputCandy player selection and settings rooms somehow in your game.
  
  4. Test.  You're good!
  
  5. Re-style the look of the InputCandy selection and settings rooms.
  
  6. Optional but appreciated:
     Add InputCandy and Lost Astronaut logos found in the marketplace/ folder to your game
	 documentation, website and startup screens.
  
*/  


////////// enumerations and global macros


#macro none noone
#macro AXIS_NO_VALUE -10000

// Types of input devices.
#macro ICDeviceType_nothing 0
#macro ICDeviceType_keyboard 1
#macro ICDeviceType_gamepad 2
#macro ICDeviceType_mouse 3
#macro ICDeviceType_keyboard_mouse 4
#macro ICDeviceType_touchscreen 5
#macro ICDeviceType_any 6
function ICDeviceTypeString(i) {
	switch (i) {
		case ICDeviceType_nothing: return "nothing";
		case ICDeviceType_keyboard: return "keyboard";
		case ICDeviceType_gamepad: return "gamepad";
		case ICDeviceType_mouse: return "mouse";
		case ICDeviceType_keyboard_mouse: return "keyboard+mouse";
		case ICDeviceType_touchscreen: return "touch";
		case ICDeviceType_any: return "any";
		default: return "?";
	}
}
		

#macro ICKeyboardLayout_qwerty 0
#macro ICKeyboardLayout_azerty 1
#macro ICKeyboardLayout_qwertz 2

#macro ICGamepad_Hat_U 1
#macro ICGamepad_Hat_R 2
#macro ICGamepad_Hat_D 4
#macro ICGamepad_Hat_L 8

/*
 Button signals
 I'm from the US so it's US-based, but provides AZERTY and QWERTZ alternative names to rectify this.
 Call it by the QWERTY name
 */
#macro IC_none 0
#macro IC_anykey 1
#macro IC_left 2		// Not directly tied to a key, this maps specially to indicate "left" similar to InputCandySimple see below
#macro IC_right	3		// Not directly tied to a key, this maps specially to indicate "left" similar to InputCandySimple see below
#macro IC_up 4			// Not directly tied to a key, this maps specially to indicate "left" similar to InputCandySimple see below
#macro IC_down 5			// Not directly tied to a key, this maps specially to indicate "left" similar to InputCandySimple see below
#macro IC_A 6
#macro IC_B 7
#macro IC_AandB 8
#macro IC_X 9
#macro IC_Y 10
#macro IC_XandY 11
#macro IC_start 12
#macro IC_back_select 13
#macro IC_Ltrigger 14
#macro IC_Rtrigger 15
#macro IC_Lshoulder 16
#macro IC_Rshoulder 17
#macro IC_Lstick 18
#macro IC_Rstick 19
#macro IC_padu 20
#macro IC_padd 21
#macro IC_padl 22
#macro IC_padr 23
#macro IC_mouse_left 24
#macro IC_mouse_right 25
#macro IC_mouse_middle 26
#macro IC_mouse_scrollup 27
#macro IC_mouse_scrolldown 28
#macro IC_key_arrow_L 29
#macro IC_key_arrow_R 30
#macro IC_key_arrow_U 31
#macro IC_key_arrow_D 32
#macro IC_backspace 33
#macro IC_any_alt 34
#macro IC_any_shift 35
#macro IC_any_control 36
#macro IC_lalt 37
#macro IC_ralt 38
#macro IC_lctrl 39
#macro IC_rctrl 40
#macro IC_lshift 41
#macro IC_rshift 42
#macro IC_tab 43
#macro IC_pause 44
#macro IC_print 45
#macro IC_pgup 46
#macro IC_pgdn 47
#macro IC_home 48
#macro IC_end 49
#macro IC_insert 50
#macro IC_delete 51
#macro IC_numpad0 52
#macro IC_numpad1 53
#macro IC_numpad2 54
#macro IC_numpad3 55
#macro IC_numpad4 56
#macro IC_numpad5 57
#macro IC_numpad6 58
#macro IC_numpad7 59
#macro IC_numpad8 60
#macro IC_numpad9 61
#macro IC_numpad_multiply 62 /* numpad * */
#macro IC_numpad_divide 63  /* numpad / */
#macro IC_numpad_subtract 64 /* numpad - */
#macro IC_numpad_decimal 65 /* numpad . */
#macro IC_f1 66
#macro IC_f2 67
#macro IC_f3 68
#macro IC_f4 69
#macro IC_f5 70
#macro IC_f6 71
#macro IC_f7 72
#macro IC_f8 73
#macro IC_f9 74
#macro IC_f10 75
#macro IC_f11 76
#macro IC_f12 77
#macro IC_key_A 78
#macro IC_key_B 79
#macro IC_key_C 80
#macro IC_key_D 81
#macro IC_key_E 82
#macro IC_key_F 83
#macro IC_key_G 84
#macro IC_key_H 85
#macro IC_key_I 86
#macro IC_key_J 87
#macro IC_key_K 88
#macro IC_key_L 89
#macro IC_key_M 90
#macro IC_key_N 91
#macro IC_key_O 92
#macro IC_key_P 93
#macro IC_key_Q 94
#macro IC_key_R 95
#macro IC_key_S 96
#macro IC_key_T 97
#macro IC_key_U 98
#macro IC_key_V 99
#macro IC_key_W 100
#macro IC_key_X 101
#macro IC_key_Y 102
#macro IC_key_Z 103
#macro IC_key_0 104
#macro IC_key_1 105
#macro IC_key_2 106
#macro IC_key_3 107
#macro IC_key_4 108
#macro IC_key_5 109
#macro IC_key_6 110
#macro IC_key_7 111
#macro IC_key_8 112
#macro IC_key_9 113
#macro IC_key_backtick 114
#macro IC_key_comma 115
#macro IC_key_period 116
#macro IC_key_slash 117
#macro IC_key_backslash 118
#macro IC_key_minus 119
#macro IC_key_equals 120
#macro IC_key_lbracket 121
#macro IC_key_rbracket 122
#macro IC_key_semi 123
#macro IC_key_apostrophe 124
#macro IC_enter 125
#macro IC_space 126
#macro IC_key_escape 127
#macro IC_hat0_U 128
#macro IC_hat0_D 129
#macro IC_hat0_L 130
#macro IC_hat0_R 131
#macro IC_hat1_U 132
#macro IC_hat1_D 133
#macro IC_hat1_L 134
#macro IC_hat1_R 135
#macro IC_hat2_U 136
#macro IC_hat2_D 137
#macro IC_hat2_L 138
#macro IC_hat2_R 139
#macro IC_hat3_U 140
#macro IC_hat3_D 141
#macro IC_hat3_L 142
#macro IC_hat3_R 143
#macro IC_hat4_U 144
#macro IC_hat4_D 145
#macro IC_hat4_L 146
#macro IC_hat4_R 147


#macro __FIRST_GAMEPAD_SIGNAL 6
#macro __LAST_GAMEPAD_SIGNAL_PLUS_1 24
#macro __FIRST_MOUSE_SIGNAL 24
#macro __LAST_MOUSE_SIGNAL_PLUS_1 28
#macro __FIRST_KEYBOARD_SIGNAL 29
#macro __LAST_KEYBOARD_SIGNAL_PLUS_1 124

#macro ICKeyboardMethod_none 0
#macro ICKeyboardMethod_keycheck 1
#macro ICKeyboardMethod_keycheck_direct 2
#macro ICKeyboardMethod_ord 3
#macro ICKeyboardMethod_lastkey 4


// Called "once" to initialize everything.

function __Private_Init_InputCandy() {

global._INPUTCANDY_DEFAULTS_ = {
 //// Global Settings ////
 ready: false,                            // Has IC been initialized?
 max_players: 8,                          // Default value for SetMaxPlayers()
 allow_keyboard_mouse: true,              // If the platform supports it, setting this true will use keyboard_and_mouse as an input device
 keyboard_layout: ICKeyboardLayout_qwerty,                // Changing to Azerty or Qwertz provides a remapping for keyboards
 keyboard_mouse_gamepad1_same: true,	  // A global setting that treats the keyboard, mouse and controller 1 as a single device.
 skip_simplified_axis: false,             // Set this value to true to stop IC from registering simplified axis movements.
 sdl_mapping_default: "None",             // Set this default from a line from the SDL_GameControllerDB, or let the player choose, "none" means "GameMaker's Default"
 use_network: false,                      // Turn this on if you are going to be using network transmits
 player_selectable_devices: { nothing: false, keyboard: false, gamepad: true, mouse: false, keyboard_mouse: true, any: false },  // Leave this alone probably.
 interface: New_InputCandy(),             // Public - the programmer interface used in your game.  All you need to know.
 internal: New_InputCandy_Private(),      // Functions used internally, generally not to be called, use interface instead, "private"
 actions: [],                             // A list of Designer-defined actions ("verbs"), set by the interface
 devices: [],                             // A list of detected devices and their capabilities and remappings
 states: [],                              // A list of device states detected each frame that correspond in index to their associated device
 previous_devices: [],                    // A list of previous devices known about particular slots but not currently connected.  Init() establishes this as a stack. TODO
 signals: [],                             // Master collection of signals from all device types supported.
 players: [],                             // A list of player "slots", active setting info, and their status and device association, device state
 settings: [],                            // List of "stored" and associatable settings
 setups:  [],                             // Holds on to previous sessions where players have been associated with devices
 network: {},
 platform: {},                            // Platform information acquired from GML
 //// Events that can be overridden: ////
 // Set this to a different function to trigger your own custom reaction to this event.
 e_controller_connected:    function( slot_id ) { show_debug_message("Controller connected!"+int(slot_id)); },
 // Set this to a different function to trigger your own custom reaction to this event.
 e_controller_disconnected: function( slot_id ) { show_debug_message("Controller disconnected!"+int(slot_id)); },
 // Default action for saving the settings file (sandboxed on most systems, only change if you need to)
 e_save_settings_file:      function( json_data ) { save_json( "control_settings.json", json_data ); },
 e_load_settings_file:      function( default_json ) { return load_json( "control_settings.json", default_json ); },
 // What to do when a player wants to join.  This is useful if you wish for players to become active at any time, but can be handled another way
 e_inactive_player_pressed_start:     function( player_number ) {} //show_debug_message("Player wants to start! "+string_format(player_number,1,0)); }
};

// This is the global variable where the persistent state of InputCandy is stored.   __IC.interface references this global profile.
__INPUTCANDY = global._INPUTCANDY_DEFAULTS_;

__INPUTCANDY.platform = __ICI.GetPlatformSpecifics();

__INPUTCANDY.signals = [
 {	index:0,    code: IC_none,		 name: "None",  deviceType: ICDeviceType_any },
 {	index:1,    code: IC_anykey,	 name: "Any",   deviceType: ICDeviceType_any },
 {	index:2,    code: IC_left=0,	 name: "Left",  deviceType: ICDeviceType_any },
 {	index:3,    code: IC_right,		 name: "Right", deviceType: ICDeviceType_any },
 {	index:4,    code: IC_up,		 name: "Up",    deviceType: ICDeviceType_any },
 {	index:5,    code: IC_down,		 name: "Down",  deviceType: ICDeviceType_any },
 {	index:6,    code: IC_A,			 name: "A",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face1 }, //__FIRST_GAMEPAD_SIGNAL
 {	index:7,    code: IC_B,			 name: "B",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face2 },
 {	index:8,    code: IC_AandB,		 name: "AandB",          deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:9,    code: IC_X,			 name: "X",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face3 },
 {	index:10,   code: IC_Y,			 name: "Y",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face4 },
 {	index:11,   code: IC_XandY,		 name: "XandY",          deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:12,   code: IC_start,		 name: "Start",          deviceType: ICDeviceType_gamepad, deviceCode: gp_start },
 {	index:13,   code: IC_back_select,   name: "Back/Select", deviceType: ICDeviceType_gamepad, deviceCode: gp_select },
 {	index:14,   code: IC_Ltrigger,	 name: "Left Trigger",   deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderlb },
 {	index:15,   code: IC_Rtrigger,	 name: "Right Trigger",  deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderrb },
 {	index:16,   code: IC_Lshoulder,	 name: "Left Shoulder",  deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderl },
 {	index:17,   code: IC_Rshoulder,	 name: "Right Shoulder", deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderr },
 {	index:18,   code: IC_Lstick,	 name: "Left Stick",     deviceType: ICDeviceType_gamepad, deviceCode: gp_stickl },
 {	index:19,   code: IC_Rstick,	 name: "Right Stick",    deviceType: ICDeviceType_gamepad, deviceCode: gp_stickr },
 {	index:20,   code: IC_padu,		 name: "Pad Up",         deviceType: ICDeviceType_gamepad, deviceCode: gp_padu },
 {	index:21,   code: IC_padd,		 name: "Pad Down",       deviceType: ICDeviceType_gamepad, deviceCode: gp_padd },
 {	index:22,   code: IC_padl,		 name: "Pad Left",       deviceType: ICDeviceType_gamepad, deviceCode: gp_padl },
 {	index:23,   code: IC_padr,		 name: "Pad Right",      deviceType: ICDeviceType_gamepad, deviceCode: gp_padr },
 {  index:24,   code: IC_mouse_left,     name: "LMB",         deviceType: ICDeviceType_mouse }, //__FIRST_MOUSE_SIGNAL
 {  index:25,   code: IC_mouse_right,	 name: "RMB",         deviceType: ICDeviceType_mouse },
 {  index:26,   code: IC_mouse_middle,	 name: "MMB",         deviceType: ICDeviceType_mouse },
 {  index:27,   code: IC_mouse_scrollup, name: "Scroll Up",   deviceType: ICDeviceType_mouse },
 {  index:28,   code: IC_mouse_scrolldown,  name: "Scroll Down", deviceType: ICDeviceType_mouse },
 {	index:29,   code: IC_key_arrow_L,	 name: "Left Arrow",     azerty_name: "Left Arrow",  qwertz_name:"Left Arrow",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck },
 {	index:30,   code: IC_key_arrow_R,	 name: "Right Arrow",    azerty_name: "Right Arrow", qwertz_name:"Right Arrow", deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck },
 {	index:31,   code: IC_key_arrow_U,	 name: "Up Arrow",       azerty_name: "Up Arrow",    qwertz_name:"Up Arrow",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck },
 {	index:32,   code: IC_key_arrow_D,	 name: "Down Arrow",     azerty_name: "Down Arrow",  qwertz_name:"Down Arrow",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck },
 {  index:33,   code: IC_backspace,      name: "BKSP",    azerty_name: "BKSP",    qwertz_name: "BKSP",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_backspace },
 {	index:34,   code: IC_any_alt,		 name: "ALT",     azerty_name: "ALT",     qwertz_name: "ALT",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_alt  },
 {	index:35,   code: IC_any_shift,		 name: "SHIFT",   azerty_name: "SHIFT",   qwertz_name: "SHIFT",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_shift },
 {	index:36,   code: IC_any_control,	 name: "CTRL",    azerty_name: "CTRL",    qwertz_name: "CTRL",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_control },
 {	index:37,   code: IC_lalt,			 name: "L-Alt",   azerty_name: "L-Alt",   qwertz_name: "L-Alt",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck_direct, keycode: vk_lalt },
 {	index:38,   code: IC_ralt,			 name: "R-Alt",   azerty_name: "R-Alt",   qwertz_name: "AltGr",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck_direct, keycode: vk_ralt },
 {	index:39,   code: IC_lctrl,			 name: "L-CTRL",  azerty_name: "L-CTRL",  qwertz_name: "L-CTRL",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck_direct, keycode: vk_lcontrol },
 {	index:40,   code: IC_rctrl,			 name: "R-CTRL",  azerty_name: "R-CTRL",  qwertz_name: "R-CTRL",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck_direct, keycode: vk_rcontrol },
 {	index:41,   code: IC_lshift,		 name: "L-SHIFT", azerty_name: "L-SHIFT", qwertz_name: "L-SHIFT", deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck_direct, keycode: vk_lshift },
 {	index:42,   code: IC_rshift,		 name: "R-SHIFT", azerty_name: "R-SHIFT", qwertz_name: "R-SHIFT", deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck_direct, keycode: vk_rshift },
 {	index:43,   code: IC_tab,			 name: "TAB",     azerty_name: "TAB",     qwertz_name: "TAB",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_tab },
 {	index:44,   code: IC_pause,			 name: "Pause",   azerty_name: "Pause",   qwertz_name: "Pause",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_pause },
 {	index:45,   code: IC_print,			 name: "PrnScr",  azerty_name: "PrnScr",  qwertz_name: "PrnScr",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_printscreen },
 {	index:46,   code: IC_pgup,			 name: "PGUP",    azerty_name: "PGUP",    qwertz_name: "PGUP",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_pageup },
 {	index:47,   code: IC_pgdn,			 name: "PGDN",    azerty_name: "PGDN",    qwertz_name: "PGDN",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_pagedown },
 {	index:48,   code: IC_home,			 name: "HOME",    azerty_name: "HOME",    qwertz_name: "HOME",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_home },
 {	index:49,   code: IC_end,			 name: "END",     azerty_name: "END",     qwertz_name: "END",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_end },
 {	index:50,   code: IC_insert,		 name: "INS",     azerty_name: "INS",     qwertz_name: "INS",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_insert },
 {	index:51,   code: IC_delete,		 name: "DEL",     azerty_name: "DEL",     qwertz_name: "DEL",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_delete },
 {	index:52,   code: IC_numpad0,		 name: "Num-0",   azerty_name: "Num-0",   qwertz_name: "Num-0",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad0 },
 {	index:53,   code: IC_numpad1,		 name: "Num-1",   azerty_name: "Num-1",   qwertz_name: "Num-1",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad1 },
 {	index:54,   code: IC_numpad2,		 name: "Num-2",   azerty_name: "Num-2",   qwertz_name: "Num-2",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad2 },
 {	index:55,   code: IC_numpad3,		 name: "Num-3",   azerty_name: "Num-3",   qwertz_name: "Num-3",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad3 },
 {	index:56,   code: IC_numpad4,		 name: "Num-4",   azerty_name: "Num-4",   qwertz_name: "Num-4",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad4 },
 {	index:57,   code: IC_numpad5,		 name: "Num-5",   azerty_name: "Num-5",   qwertz_name: "Num-5",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad5 },
 {	index:58,   code: IC_numpad6,		 name: "Num-6",   azerty_name: "Num-6",   qwertz_name: "Num-6",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad6 },
 {	index:59,   code: IC_numpad7,		 name: "Num-7",   azerty_name: "Num-7",   qwertz_name: "Num-7",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad7 },
 {	index:60,   code: IC_numpad8,		 name: "Num-8",   azerty_name: "Num-8",   qwertz_name: "Num-8",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad8 },
 {	index:61,   code: IC_numpad9,		 name: "Num-9",   azerty_name: "Num-9",   qwertz_name: "Num-9",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_numpad9 },
 {	index:62,   code: IC_numpad_multiply, name: "Num *",   azerty_name: "Num *",   qwertz_name: "Num *",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_multiply },
 {	index:63,   code: IC_numpad_divide,   name: "Num /",   azerty_name: "Num /",   qwertz_name: "Num /",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_divide },
 {	index:64,   code: IC_numpad_subtract, name: "Num -",   azerty_name: "Num -",   qwertz_name: "Num -",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_subtract },
 {	index:65,   code: IC_numpad_decimal,  name: "Num .",   azerty_name: "Num .",   qwertz_name: "Num .",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_decimal },
 {	index:66,   code: IC_f1,		     name: "F1",      azerty_name: "F1",      qwertz_name: "F1",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f1 },
 {	index:67,   code: IC_f2,		     name: "F2",      azerty_name: "F2",      qwertz_name: "F2",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f2 },
 {	index:68,   code: IC_f3,		     name: "F3",      azerty_name: "F3",      qwertz_name: "F3",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f3 },
 {	index:69,   code: IC_f4,		     name: "F4",      azerty_name: "F4",      qwertz_name: "F4",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f4 },
 {	index:70,   code: IC_f5,		     name: "F5",      azerty_name: "F5",      qwertz_name: "F5",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f5 },
 {	index:71,   code: IC_f6,		     name: "F6",      azerty_name: "F6",      qwertz_name: "F6",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f6 },
 {	index:72,   code: IC_f7,		     name: "F7",      azerty_name: "F7",      qwertz_name: "F7",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f7 },
 {	index:73,   code: IC_f8,		     name: "F8",      azerty_name: "F8",      qwertz_name: "F8",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f8 },
 {	index:74,   code: IC_f9,		     name: "F9",      azerty_name: "F9",      qwertz_name: "F9",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f9 },
 {	index:75,   code: IC_f10,		     name: "F10",     azerty_name: "F10",     qwertz_name: "F10",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f10 },
 {	index:76,   code: IC_f11,		     name: "F11",     azerty_name: "F11",     qwertz_name: "F11",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f11 },
 {	index:77,   code: IC_f12,		     name: "F12",     azerty_name: "F12",     qwertz_name: "F12",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f12 },
 {	index:78,   code: IC_key_A,		 name: "Key A",   azerty_name: "Key Q",   qwertz_name: "Key A",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "A" },
 {	index:79,   code: IC_key_B,		 name: "Key B",   azerty_name: "Key B",   qwertz_name: "Key B",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "B" },
 {	index:80,   code: IC_key_C,		 name: "Key C",   azerty_name: "Key C",   qwertz_name: "Key C",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "C" },
 {	index:81,   code: IC_key_D,		 name: "Key D",   azerty_name: "Key D",   qwertz_name: "Key D",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "D" },
 {	index:82,   code: IC_key_E,		 name: "Key E",   azerty_name: "Key E",   qwertz_name: "Key E",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "E" },
 {	index:83,   code: IC_key_F,		 name: "Key F",   azerty_name: "Key F",   qwertz_name: "Key F",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "F" },
 {	index:84,   code: IC_key_G,		 name: "Key G",   azerty_name: "Key G",   qwertz_name: "Key G",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "G" },
 {	index:85,   code: IC_key_H,		 name: "Key H",   azerty_name: "Key H",   qwertz_name: "Key H",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "H" },
 {	index:86,   code: IC_key_I,		 name: "Key I",   azerty_name: "Key I",   qwertz_name: "Key I",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "I" },
 {	index:87,   code: IC_key_J,		 name: "Key J",   azerty_name: "Key J",   qwertz_name: "Key J",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "J" },
 {	index:88,   code: IC_key_K,		 name: "Key K",   azerty_name: "Key K",   qwertz_name: "Key K",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "K" },
 {	index:89,   code: IC_key_L,		 name: "Key L",   azerty_name: "Key L",   qwertz_name: "Key L",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "L" },
 {	index:90,   code: IC_key_M,		 name: "Key M",   azerty_name: "Key M",   qwertz_name: "Key M",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "M" },
 {	index:91,   code: IC_key_N,		 name: "Key N",   azerty_name: "Key N",   qwertz_name: "Key N",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "N" },
 {	index:92,   code: IC_key_O,		 name: "Key O",   azerty_name: "Key O",   qwertz_name: "Key O",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "O" },
 {	index:93,   code: IC_key_P,		 name: "Key P",   azerty_name: "Key P",   qwertz_name: "Key P",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "P" },
 {	index:94,   code: IC_key_Q,		 name: "Key Q",   azerty_name: "Key A",   qwertz_name: "Key Q",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "Q" },
 {	index:95,   code: IC_key_R,		 name: "Key R",   azerty_name: "Key R",   qwertz_name: "Key R",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "R" },
 {	index:96,   code: IC_key_S,		 name: "Key S",   azerty_name: "Key S",   qwertz_name: "Key S",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "S" },
 {	index:97,   code: IC_key_T,		 name: "Key T",   azerty_name: "Key R",   qwertz_name: "Key T",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "T" },
 {	index:98,   code: IC_key_U,		 name: "Key U",   azerty_name: "Key U",   qwertz_name: "Key Y",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "U" },
 {	index:99,   code: IC_key_V,		 name: "Key V",   azerty_name: "Key V",   qwertz_name: "Key V",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "V" },
 {	index:100,  code: IC_key_W,		 name: "Key W",   azerty_name: "Key Z",   qwertz_name: "Key W",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "W" },
 {	index:101,  code: IC_key_X,		 name: "Key X",   azerty_name: "Key X",   qwertz_name: "Key X",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "X" },
 {	index:102,  code: IC_key_Y,		 name: "Key Y",   azerty_name: "Key Y",   qwertz_name: "Key Z",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "Y" },
 {	index:103,  code: IC_key_Z,		 name: "Key Z",   azerty_name: "Key W",   qwertz_name: "Key Y",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "Z" },
 {	index:104,  code: IC_key_0,		 name: "Key 0",   azerty_name: "Key 0",   qwertz_name: "Key 0",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "0" },
 {	index:105,  code: IC_key_1,		 name: "Key 1",   azerty_name: "Key 1",   qwertz_name: "Key 1",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "1" },
 {	index:106,  code: IC_key_2,		 name: "Key 2",   azerty_name: "Key 2",   qwertz_name: "Key 2",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "2" },
 {	index:107,  code: IC_key_3,		 name: "Key 3",   azerty_name: "Key 3",   qwertz_name: "Key 3",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "3" },
 {	index:108,  code: IC_key_4,		 name: "Key 4",   azerty_name: "Key 4",   qwertz_name: "Key 4",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "4" },
 {	index:109,  code: IC_key_5,		 name: "Key 5",   azerty_name: "Key 5",   qwertz_name: "Key 5",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "5" },
 {	index:110,  code: IC_key_6,		 name: "Key 6",   azerty_name: "Key 6",   qwertz_name: "Key 6",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "6" },
 {	index:111,  code: IC_key_7,		 name: "Key 7",   azerty_name: "Key 7",   qwertz_name: "Key 7",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "7" },
 {	index:112,  code: IC_key_8,		 name: "Key 8",   azerty_name: "Key 8",   qwertz_name: "Key 8",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "8" },
 {	index:113,  code: IC_key_9,		 name: "Key 9",   azerty_name: "Key 9",   qwertz_name: "Key 9",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "9" },
 {	index:114,  code: IC_key_backtick,	 name: "Backtick",      azerty_name: "Backtick",      qwertz_name:"Backtick",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "`" , shifted: "~" },
 {	index:115,  code: IC_key_comma,		 name: "Comma",         azerty_name: "Comma",         qwertz_name:"Comma",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "," , shifted: "<" },
 {	index:116,  code: IC_key_period,	 name: "Period",        azerty_name: "Period",        qwertz_name:"Period",        deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "." , shifted: ">" },
 {	index:117,  code: IC_key_slash,		 name: "Slash",         azerty_name: "Slash",         qwertz_name:"Slash",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "/" , shifted: "?" },
 {	index:118,  code: IC_key_backslash,  name: "Backslash",     azerty_name: "Backslash",     qwertz_name:"Backslash",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "\\", shifted: "|" },
 {	index:119,  code: IC_key_minus,		 name: "Minus",         azerty_name: "Minus",         qwertz_name:"Minus",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "-" , shifted: "_" },
 {	index:120,  code: IC_key_equals,	 name: "Equals",        azerty_name: "Equals",        qwertz_name:"Equals",        deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "=" , shifted: "+" },
 {	index:121,  code: IC_key_lbracket,	 name: "Left Bracket",  azerty_name: "Left Bracket",  qwertz_name:"Left Bracket",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "[" , shifted: "{" },
 {	index:122,  code: IC_key_rbracket,	 name: "Right Bracket", azerty_name: "Right Bracket", qwertz_name:"Right Bracket", deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "]" , shifted: "}" },
 {	index:123,  code: IC_key_semi,		 name: "Semicolon",     azerty_name: "Semicolon",     qwertz_name:"Semicolon",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: ";" , shifted: ":" },
 {	index:124,  code: IC_key_apostrophe, name: "Apostrophe",    azerty_name: "Apostrophe",    qwertz_name:"Apostrophe",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "'" , shifted: "\"" },
 {	index:125,  code: IC_enter,          name: "Enter",			azerty_name: "Enter",         qwertz_name:"Enter",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "\n" , shifted: "\n" },
 {	index:126,  code: IC_space,          name: "Space",			azerty_name: "Space",         qwertz_name:"Space",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: " " , shifted: " " },
 {	index:127,  code: IC_key_escape,     name: "Escape",		azerty_name: "Escape",        qwertz_name:"Escape",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: chr(27), shifted: chr(27) },
 {	index:128,  code: IC_hat0_U,		 name: "Hat0 Up",       deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:129,  code: IC_hat0_D,		 name: "Hat0 Down",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:130,  code: IC_hat0_L,		 name: "Hat0 Left",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:131,  code: IC_hat0_R,	     name: "Hat0 Right",	deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:132,  code: IC_hat1_U,		 name: "Hat1 Up",       deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:133,  code: IC_hat1_D,		 name: "Hat1 Down",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:134,  code: IC_hat1_L,		 name: "Hat1 Left",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:135,  code: IC_hat1_R,	     name: "Hat1 Right",	deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:136,  code: IC_hat2_U,		 name: "Hat2 Up",       deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:137,  code: IC_hat2_D,		 name: "Hat2 Down",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:138,  code: IC_hat2_L,		 name: "Hat2 Left",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:139,  code: IC_hat2_R,	     name: "Hat2 Right",	deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:140,  code: IC_hat3_U,		 name: "Hat3 Up",       deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:141,  code: IC_hat3_D,		 name: "Hat3 Down",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:142,  code: IC_hat3_L,		 name: "Hat3 Left",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:143,  code: IC_hat3_R,	     name: "Hat3 Right",	deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:144,  code: IC_hat4_U,		 name: "Hat4 Up",       deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:145,  code: IC_hat4_D,		 name: "Hat4 Down",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:146,  code: IC_hat4_L,		 name: "Hat4 Left",     deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:147,  code: IC_hat4_R,	     name: "Hat4 Right",	deviceType: ICDeviceType_gamepad, deviceType: ICDeviceType_gamepad, deviceCode: none },
];

__INPUTCANDY.SDL_GameControllerDB = [];

__ICI.Init();
__INPUTCANDY.ready=true;

__Init_ICUI();
}

// This function is invoked and stored in __IC.interface, but you can call it anywhere to grab an "instance" of all
// of the InputCandy functions.
function New_InputCandy() {
	return {
		// Call this in a controller object's Step event, once per frame
		Step: function () { __ICI.Step(); },
		// @description Adds an action to the global action list, second optional argument is group name.  "None" is the default group name.  Don't save action indexes to savegames or settings files.
		// @param verb_string A string to look the action up by.
		// @param group_name A group name (optional parameter)
		Action: function ( verb_string ) {
			var a=__ICI.New_ICAction();
			a.name=verb_string;
			if ( argument_count > 1 ) { // Group this action.
				a.group=argument1;
			}
			a.index = array_length(__INPUTCANDY.actions);
			__INPUTCANDY.actions[a.index]=a;
			return a.index;
		},
		Actions: function ( action_list ) {
			var len=array_length(action_list);
			for ( var i=0; i<len; i++ ) {
				__IC.Action( action_list[i].name, action_list[i].group );
			}
		},
		// Get Action from list by name, if you pass a second argument, it requires it to be in the same group.
		GetAction: function ( name /*, group*/ ) {
			var len=array_length(__INPUTCANDY.actions);
			if ( argument_count > 1 ) {
				for ( var i=0; i<len; i++ )	if ( __INPUTCANDY.actions[i].name == name and __INPUTCANDY.actions[i].group == argument1 ) return i;
			} else {
				for ( var i=0; i<len; i++ ) if ( __INPUTCANDY.actions[i].name == name ) return i;
			}
		},
		// Returns a list of action indexes referring to actions in the same named group.  Pass "None" for ungrouped actions.
		GetActionGroup: function ( groupname ) {
			var result=[];
			var len=array_length(__INPUTCANDY.actions);
			for ( var i=0; i<len; i++ ) {
				if ( __INPUTCANDY.actions[i].group == groupname ) result[array_length(result)]=i;
			}
			return result;
		},
		GetActionByIndex: function (player_number, action_index) { return __INPUTCANDY.actions[action_index]; },
		// Checks a specific player&device&binding pairing for presence of a provided action
		Check: function ( player_number, action ) {
		},
		// Checks _any_ player for an action
		CheckAny: function ( action ) {
		},
		// Directly checks a signal, bypassing the Actions system, -1 means "none", otherwise # of frames its been held for
		Signal: function ( player_number, button_id ) {
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none or device >= array_length(__INPUTCANDY.devices) ) return 0;
			var len=array_length(__INPUTCANDY.states[device].signals);
			for ( var i=0; i<len; i++ ) {
				if ( __INPUTCANDY.states[device].signals[i].button == button_id and __INPUTCANDY.states[device].signals[i].is_held ) return __INPUTCANDY.states[device].signals[i].held_for;
			}
		},
		// Directly checks signals from any device, bypassing the Actions system
		SignalAny: function ( button_id ) {
			var len=array_length(__INPUTCANDY.devices);
			for ( var i=0; i<len; i++ ) {
				var sigs=array_length(__INPUTCANDY.states[i].signals);
				for ( var j=0; j<sigs; j++ ) {
					if ( __INPUTCANDY.states[i].signals[j].button == button_id and __INPUTCANDY.states[i].signals[j].is_held ) return __INPUTCANDY.states[i].signals[j].held_for;
				}
			}
			return 0;
		},
		// Directly checks a signal, bypassing the Actions system, -1 means "none", otherwise # of frames its been held for
		SignalReleased: function ( player_number, button_id ) {
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none or device >= array_length(__INPUTCANDY.devices) ) return false;
			var len=array_length(__INPUTCANDY.states[device].signals);
			for ( var i=0; i<len; i++ ) {
				if ( __INPUTCANDY.states[device].signals[i].button == button_id
				 and __INPUTCANDY.states[device].signals[i].was_held 
				 and !__INPUTCANDY.states[device].signals[i].is_held ) return true;
			}
		},
		// Directly checks signals from any device, bypassing the Actions system
		SignalAnyReleased: function ( button_id ) {
			var len=array_length(__INPUTCANDY.devices);
			for ( var i=0; i<len; i++ ) {
				var sigs=array_length(__INPUTCANDY.states[i].signals);
				for ( var j=0; j<sigs; j++ ) {
					if ( __INPUTCANDY.states[i].signals[j].button == button_id
					 and __INPUTCANDY.states[i].signals[j].was_held
					 and !__INPUTCANDY.states[i].signals[j].is_held ) return true;
				}
			}
			return 0;
		},
		AxisToAngle: function ( H, V ) { return point_direction(0, 0, H, V); },
		// 
		AssignPlayerDevice: function( player_number, device_profile_index ) {
		},
		// Allocates a series of player profiles.  This is where you set your game's max players.  14 is a device maximum on Linux, 12 of Windows, 4 on Mac
		SetMaxPlayers: function ( max_players ) {
			var player_list=[];
			var len=array_length(__INPUTCANDY.players);
			for ( var i=0; i<max_players; i++ ) {
			  if ( i < len ) player_list[i]=__INPUTCANDY.players[i];
			  else player_list[i]=__ICI.New_ICPlayer();
			}
			__INPUTCANDY.max_players=max_players;
			__INPUTCANDY.players=player_list;
		},
		// Returns the number of active players
		GetPlayers: function () {
		},
		ParseDeviceGUIDs: function() {
			var len=array_length(__INPUTCANDY.devices);
			for ( var i=0; i<len; i++ ) {
				if ( __INPUTCANDY.devices[i].guid != "none" and string_length(__INPUTCANDY.devices[i].guid) > 0 ) {
					__INPUTCANDY.devices[i].sdl=SDLDB_Lookup_GUID(__INPUTCANDY.devices[i].guid );
				}
			}
		},
		DiagnosticsString: function() {
			var verbose=true;
			if ( argument_count > 0 ) {
				verbose=argument0;
			}
			var out="Active Devices:\n";
			var len=array_length(__INPUTCANDY.devices);
			var slen=array_length(__INPUTCANDY.states);
			for ( var i=0; i<len; i++ ) {
				if ( verbose ) {
					i=i;
					out += int(i)+"# "+__INPUTCANDY.devices[i].desc+":"+__INPUTCANDY.devices[i].sdl.name+":"+__INPUTCANDY.devices[i].guid+"\n"+__ICI.ICDevicePrintDiagnostics_Verbose(__INPUTCANDY.devices[i])+"\n";
					if ( i < slen ) out += "   "+__ICI.ICDeviceStatePrintDiagnostics_Verbose(__INPUTCANDY.states[i])+"\n";
				} else {
					out += int(i)+"# "+__INPUTCANDY.devices[i].desc+":"+__INPUTCANDY.devices[i].sdl.name+":"+__INPUTCANDY.devices[i].guid+"\n"+__ICI.ICDevicePrintDiagnostics(__INPUTCANDY.devices[i])+"\n";
					if ( i < slen ) out += "   "+__ICI.ICDeviceStatePrintDiagnostics(__INPUTCANDY.states[i])+"\n";
				}
			}
			return out;
		},
		DiagnosticsVibrate: function () {
			var len=array_length(__INPUTCANDY.devices);
			var slen=array_length(__INPUTCANDY.states);
			for ( var i=0; i<len; i++ ) {
				if ( i < slen ) {
					if ( array_length(__INPUTCANDY.states[i].signals) > 0 ) gamepad_set_vibration(__INPUTCANDY.devices[i].slot_id,1,1);
					else gamepad_set_vibration(__INPUTCANDY.devices[i].slot_id,abs(__INPUTCANDY.states[i].LH+__INPUTCANDY.states[i].RH),abs(__INPUTCANDY.states[i].LV+__INPUTCANDY.states[i].RV));
				} else gamepad_set_vibration(__INPUTCANDY.devices[i].slot_id,0,0);
			}
		}
		
	};
}


// These are internal functions, used by InputCandy -- where the "deep work" happens.



function New_InputCandy_Private() {
 return {
	 Step: function() {
		__ICI.GetActiveDevices();
		__ICI.GetDeviceStates();
		__ICI.AssignUnusedDevices();
	    if ( __INPUTCANDY.use_network ) __ICI.UpdateNetwork();
	 },
	 Init: function() {
		__INPUTCANDY.platform = __ICI.GetPlatformSpecifics();
	 	__ICI.ReadPlayerSettings();
//		__ICI.ReadLastPlayerSetup();
		__IC.SetMaxPlayers(__INPUTCANDY.max_players);
//		__INPUTCANDY.previous_devices = ds_list_create(); TODO
	 },
	 UpdateNetwork: function() { /* TODO */ },
	 WritePlayerSettings: function( player_number, settings_name ) {
		 __IC.e_save_settings_file( { settings: __INPUTCANDY.settings, setups: __INPUTCANDY.setups } );
	 },
	 ReadPlayerSettings: function( player_number, settings_name ) {
		 var data = __INPUTCANDY.e_load_settings_file( { settings:[], setups:[] } );
		 __INPUTCANDY.settings = data.settings;
		 __INPUTCANDY.setups = data.setups;
	 },
	 GetPlatformSpecifics: function() {
		return {
			device: os_device,
			emulated: (os_device == device_emulator),
			type: os_type,
			version: os_version,
			browser: os_browser,
			keypad_open: device_is_keypad_open(),
			touchscreen_supported: (os_type == os_ios or os_type == os_android or os_type == os_uwp or os_type == os_tvos or os_device == device_ios_ipad or os_device == device_ios_ipad_retina or os_device == device_ios_iphone6 or os_device == device_ios_iphone6plus or os_device == device_ios_iphone5 or os_device == device_ios_iphone or os_device == device_ios_iphone_retina or os_device == device_tablet),
			keyboard_mouse_supported: (os_type == os_macosx or os_type == os_windows or os_type == os_linux ? true : false),
			gamepads_supported: gamepad_is_supported(),
			internet: os_is_network_connected(),	// Note that this state may change.
			language: os_get_language(),			// Note that this state may change, but usually won't.
			region: os_get_region(),				// Note that this state may change, but usually won't.
			config: os_get_config()					// Note that this state may change, but usually won't.
		};
	},
	/// Creating empty "classes"
	
	//// DEVICE
	New_ICDevice: function() {
		return {
			type: ICDeviceType_nothing,
			slot_id: none,
			hat_count: 0,
			button_count: 0,
			button_thresholds: [],
			axis_count: 0,
			axis_deadzones: [],
			guid: "none",
			desc: "",
			sdl: { index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" },
			index: -1
		};
	},
	ICDevicePrintDiagnostics: function( device ) {
	 return "T: "+ICDeviceTypeString(device.type)+"("+int(device.type)+") gpSlot: "+int(device.slot_id)+" Hats: "+int(device.hat_count)+" Bs: "+int(device.button_count)+" As: "+int(device.axis_count);
	},
	ICDevicePrintDiagnostics_Verbose: function ( d ) {
	 var out=__ICI.ICDevicePrintDiagnostics(d);
	 out += " Deadz: ";
	 for ( var i=0; i<d.axis_count; i++ ) out+=string_format(d.axis_deadzones[i],1,2)+",";
	 out += " Thrsh: ";
	 for ( var i=0; i<d.button_count; i++ ) out+=string_format(d.button_thresholds[i],1,2)+",";
	 return out;
	},
	IsSameICDevice: function ( a,b ) {
		if ( a.slot_id != b.slot_id ) return false;
		if ( a.hat_count != b.hat_count ) return false;
		if ( a.button_count != b.button_count ) return false;
		if ( a.axis_count != b.axis_count ) return false;
		if ( a.guid != b.guid ) return false;
		for ( var i=0; i<a.axis_count; i++ ) if ( a.axis_deadzones[i] != b.axis_deadzones[i] ) return false;
		for ( var i=0; i<a.button_count; i++ ) if ( a.button_thresholds[i] != b.button_thresholds[i] ) return false;
		return true;
	},	
	GetActiveDevices: function() {
		 var j=0;
		 var existing = array_length(__INPUTCANDY.devices);
		 var devices_list=[];
		 // Mouse, Keyboard is always "device index 0"; but only when supported and permitted to be used as an input device
		 if ( __INPUTCANDY.platform.keyboard_mouse_supported and __INPUTCANDY.allow_keyboard_mouse ) {
			 var d=__ICI.New_ICDevice();
			 d.type=ICDeviceType_keyboard_mouse;
			 d.index=j;
			 devices_list[j]=d;
			 if ( !__INPUTCANDY.keyboard_mouse_gamepad1_same ) j++;
		 }
		 // Poll all gamepad slots for connected devices.
		 var gamepads=gamepad_get_device_count();
		 for ( var i=0; i<gamepads; i++ ) {
			 if ( gamepad_is_connected(i) ) {
				var found=false;
				// See if the gamepad is already known about...
				for ( var k=0; k<existing; k++ ) if ( __INPUTCANDY.devices[k].slot_id==i ) { found=true; break; }
				if ( found ) continue;
				// In the special case that keyboard_and_mouse are activated in settings, and we're allowing the player(s) to use it
				if ( __INPUTCANDY.platform.keyboard_mouse_supported and __INPUTCANDY.allow_keyboard_mouse ) {
					// If we're in the special case of the "Device 0" position, and it's not "Device 0" index we need to create a new device profile and give it an accurate type.
					if ( __INPUTCANDY.keyboard_mouse_gamepad1_same and j != 0 ) {
						devices_list[j]=__ICI.New_ICDevice();
						devices_list[j].type = ICDeviceType_gamepad;
					} // otherwise we are writing to the "Device 0" position and the type is already set.
				} else { // No keyboard or mouse enters the picture, so give the new profile an accurate type
					devices_list[j]=__ICI.New_ICDevice();
					devices_list[j].type = ICDeviceType_gamepad;
				}
				// Associated and collect all information into the new devices list.
				devices_list[j].slot_id=i;
				devices_list[j].guid = gamepad_get_guid(i);
				devices_list[j].desc = gamepad_get_description(i);
				devices_list[j].hat_count = gamepad_hat_count(i);
				var btns= gamepad_button_count(i);
				devices_list[j].button_count = btns;
				for ( var k=0; k<btns; k++ ) devices_list[j].button_thresholds[k]=gamepad_get_button_threshold(i);
				var axes= gamepad_axis_count(i);
				devices_list[j].axis_count = axes;
				for ( var k=0; k<axes; k++ ) devices_list[j].axis_deadzones[k]=gamepad_get_axis_deadzone(i);
				devices_list[j].index=j;
				devices_list[j].sdl = SDLDB_Lookup_Device(devices_list[j]);
				j++;
			 }
		 }
		 // Append detected devices not found in the already known and connected list
		 var len=array_length(devices_list);
		 for ( var i=0; i<len; i++ ) {
			 var index=array_length(__INPUTCANDY.devices);
			 __INPUTCANDY.devices[index]=devices_list[i];
			 if ( devices_list[i].type == ICDeviceType_keyboard_mouse and index != 0 ) devices_list[i].type=ICDeviceType_gamepad;
		 }
		 // Determine if any of the already known are still connected.  If not, prune in a special case, otherwise, create a new device profile and populate it.
		 j=0;
		 devices_list=[];
		 len = array_length(__INPUTCANDY.devices);
		 for ( var i=0; i<len; i++ ) {
			 if ( __INPUTCANDY.devices[i].slot_id != none ) {
				 var connected=gamepad_is_connected(__INPUTCANDY.devices[i].slot_id);
				 // If this device profile is connected to a valid slot_id we need to copy it to the new list.
				 if ( connected or ( __INPUTCANDY.keyboard_mouse_gamepad1_same and i==0 ) ) {
					 devices_list[j]=__INPUTCANDY.devices[i];
					 devices_list[j].index = j;
					 // Unless its a special case and the gamepad is disconnected, then we're removing it from the "Device 0" position which remains as a keyboard mouse primary input
					 if ( !connected ) devices_list[j].slot_id=none;
					 j++;
				 } else { // Otherwise: It's an isolated gamepad we're going to remove it from the new devices list, disconnect it and move it to the previously known list (TODO?)
				 }
			 }
		 }
		 // If no gamepad is associated with "Device 0", and there's supposed to be at least one associated, assign the next available one to the "Device 0" position
		 if ( __INPUTCANDY.keyboard_mouse_gamepad1_same and __INPUTCANDY.platform.keyboard_mouse_supported and __INPUTCANDY.allow_keyboard_mouse ) {
			 if ( devices_list[0].slot_id == none and array_length(devices_list) > 1 ) {
				 var device_list_copy=[];
				 var list_len=array_length(devices_list);
				 device_list_copy[0]=devices_list[1];
				 device_list_copy[0].type=ICDeviceType_keyboard_mouse;
				 device_list_copy[0].index=0;
				 for ( var m=2; m<list_len; m++ ) {
					 device_list_copy[m-1]=devices_list[m];
					 device_list_copy[m-1].index=m-1;
				 }				 
				 devices_list=device_list_copy;
			 }
		 }
		 // Get the latest list and make it available.
		 __INPUTCANDY.devices=devices_list;
	 },
	 AssignUnusedDevices: function() {
	 	// TODO: Load Previously Saved Device Assignment Settings here...
	 	var device_count=array_length(__INPUTCANDY.devices);
	 	for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
			if ( __INPUTCANDY.players[i].device != none and __INPUTCANDY.players[i].device < device_count ) {
				// Check for duplicate assignments.  Earlier players get precedence.
	 			var found=0;
	 			for ( var k=0; k<__INPUTCANDY.max_players; k++ ) {
	 				if ( __INPUTCANDY.players[k].device == __INPUTCANDY.players[i].device ) found++;
					if ( found > 1 ) __INPUTCANDY.players[k].device=none;
	 			}
				continue; // Already assigned valid device and duplicates up the line were removed.
			}
			if ( __INPUTCANDY.players[i].device == none ) {
				var assigned=false;
	 			for ( var j=0; j<device_count; j++ ) {
	 				var found=false;
	 				for ( var k=0; k<__INPUTCANDY.max_players; k++ ) {
	 					if ( __INPUTCANDY.players[k].device == j ) { found=true; break; }
	 				}
					if ( found ) continue;
					else {
						__INPUTCANDY.players[i].device=j;
						assigned=true;
					}
	 			}
			}
	 	}
	 },
	 GuessBestDeviceIcon: function ( device ) {
		 if ( device == none or device == 0 ) return 9;
		 if ( device.type == ICDeviceType_keyboard ) return 10;
		 if ( device.type == ICDeviceType_mouse ) return 11;
		 if ( device.desc == "Classic Controller" ) return 7; // ATARI VCS Classic Controller
		 if ( device.guid == "5032021000000000000504944564944" ) return 8; // ATARI VCS Modern Controller
		 if ( device.axis_count == 5 and device.button_count == 17 ) return 4;
		 if ( device.axis_count == 4 and device.button_count == 17 ) return 3;
		 if ( device.axis_count == 2 and device.button_count == 10 ) return 2;
		 if ( device.axis_count == 2 and device.button_count == 8 ) return 1;
		 return 5;
	 },
	 //// BUTTONSTATE
	New_ICButtonState: function() {
		return {
			button: IC_none,
			signal_index: none,
			is_held: false,
			was_held: false,
			held_for: 0
		};
	},
	ICButtonStatePrintDiagnostics: function( b ) {
		return "Sig: "+int(b.button)+" I: "+int(b.signal_index)+" held: "+(b.is_held?"Y":"N")+" was: "+(b.was_held?"Y":"N")+" for: "+int(b.held_for);
	},
	
	 //// DEVICESTATE
	New_ICDeviceState: function() {
		return {
			signals: [],   // xbox style controller signals, the gp_* stuff
			buttons: [],   // analog buttons
			hats: [],      // hat signals
			axis: [],      // other axis values (may be duplicatous on some devices)
			// left and right stick axis for xbox style controllers
			LH: AXIS_NO_VALUE,
			LV: AXIS_NO_VALUE,
			RH: AXIS_NO_VALUE,
			RV: AXIS_NO_VALUE,
			slot_id: none
		};
	},
	ICDeviceStatePrintDiagnostics: function ( s ) {
		return "gpSlot:"+int(s.slot_id)+"S: "+int(array_length(s.signals))+"B: "+int(array_length(s.signals))+"H: "+int(array_length(s.signals))
		  +" L(v,h): "+string_format(s.LV,1,2)+","+string_format(s.LH,1,2)+" R(v,h):"+string_format(s.RV,1,2)+","+string_format(s.RH,1,2);
	},
	ICDeviceStatePrintDiagnostics_Verbose: function ( s ) {
		var out=__ICI.ICDeviceStatePrintDiagnostics(s)+"\n";
		var len=array_length(s.signals);
		for ( var i=0; i<len; i++ ) out+=" Sig#"+int(i)+" -> "+__INPUTCANDY.signals[s.signals[i].signal_index].name+" -> "+__ICI.ICButtonStatePrintDiagnostics(s.signals[i])+"\n";
		out+=" Btns: ";
		len = array_length(s.buttons);
		for ( var i=0; i<len; i++ ) out+=string_format(s.buttons[i],1,2)+",";
		out+=" Hats: ";
		len = array_length(s.hats);
		for ( var i=0; i<len; i++ ) out+=string_format(s.hats[i],1,2)+",";
		out+=" Axs: ";
		len = array_length(s.axis);
		for ( var i=0; i<len; i++ ) out+=string_format(s.axis[i],1,2)+",";
		return out;
	},
	GetDeviceStates: function() {
		var previous_states=__INPUTCANDY.states;
		var previous_states_len=array_length(previous_states);
		__INPUTCANDY.states=[];
		var len=array_length(__INPUTCANDY.devices);
		for ( var i=0; i<len; i++ ) {
			if ( __INPUTCANDY.devices[i].slot_id == none ) continue;
			var state=__ICI.New_ICDeviceState();
			state.slot_id=__INPUTCANDY.devices[i].slot_id;
			state.LH = gamepad_axis_value(state.slot_id, gp_axislh);
			state.LV = gamepad_axis_value(state.slot_id, gp_axislv);
			state.RH = gamepad_axis_value(state.slot_id, gp_axisrh);
			state.RV = gamepad_axis_value(state.slot_id, gp_axisrv);
			var hat_code=IC_hat0_U;
			for ( var k=0; k<__INPUTCANDY.devices[i].hat_count; k++ ) {
				if ( k > 4 ) break; // Can't track signals beyond hat 4
				state.hats[k]=gamepad_hat_value(state.slot_id,k);
				if ( state.hats[k]&ICGamepad_Hat_U ) { // Up is held
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					var j=array_length(state.signals);
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=hat_code;
					state.signals[j].signal_index=hat_code;
					state.signals[j].is_held = true;
					if ( found_signal != none ) {
						state.signals[j].held_for = previous_states[i].signals[found_signal].held_for+1;
						state.signals[j].was_held = true;
					} else state.signals[j].held_for = 1;
				} else { // Released
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					if ( found_signal == none or (previous_states[i].signals[found_signal].was_held and !previous_states[i].signals[found_signal].is_held) ) { /* stop tracking it */ }
					else {
						var j=array_length(state.signals);
						state.signals[j]=__ICI.New_ICButtonState();
						state.signals[j].button=hat_code;
						state.signals[j].signal_index=hat_code;
						if ( found_signal != none ) {
							state.signals[j].held_for = previous_states[i].signals[found_signal].held_for;
							state.signals[j].was_held = true;
						} else state.signals[j].held_for = 1;
					}
				}
				hat_code++;
				if ( state.hats[k]&ICGamepad_Hat_R ) { // Right is held
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					var j=array_length(state.signals);
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=hat_code;
					state.signals[j].signal_index=hat_code;
					state.signals[j].is_held = true;
					if ( found_signal != none ) {
						state.signals[j].held_for = previous_states[i].signals[found_signal].held_for+1;
						state.signals[j].was_held = true;
					} else state.signals[j].held_for = 1;
				} else { // Released
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					if ( found_signal == none or (previous_states[i].signals[found_signal].was_held and !previous_states[i].signals[found_signal].is_held) ) { /* stop tracking it */ }
					else {
						var j=array_length(state.signals);
						state.signals[j]=__ICI.New_ICButtonState();
						state.signals[j].button=hat_code;
						state.signals[j].signal_index=hat_code;
						if ( found_signal != none ) {
							state.signals[j].held_for = previous_states[i].signals[found_signal].held_for;
							state.signals[j].was_held = true;
						} else state.signals[j].held_for = 1;
					}
				}
				hat_code++;
				if ( state.hats[k]&ICGamepad_Hat_D ) { // Down is held
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					var j=array_length(state.signals);
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=hat_code;
					state.signals[j].signal_index=hat_code;
					state.signals[j].is_held = true;
					if ( found_signal != none ) {
						state.signals[j].held_for = previous_states[i].signals[found_signal].held_for+1;
						state.signals[j].was_held = true;
					} else state.signals[j].held_for = 1;
				} else { // Released
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ )
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					if ( found_signal == none or (previous_states[i].signals[found_signal].was_held and !previous_states[i].signals[found_signal].is_held) ) { /* stop tracking it */ }
					else {
						var j=array_length(state.signals);
						state.signals[j]=__ICI.New_ICButtonState();
						state.signals[j].button=hat_code;
						state.signals[j].signal_index=hat_code;
						if ( found_signal != none ) {
							state.signals[j].held_for = previous_states[i].signals[found_signal].held_for;
							state.signals[j].was_held = true;
						} else state.signals[j].held_for = 1;
					}
				}
				hat_code++;
				if ( state.hats[k]&ICGamepad_Hat_L ) { // Left is held
					var found_signal=none;
					if ( previous_states_len > i )
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					var j=array_length(state.signals);
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=hat_code;
					state.signals[j].signal_index=hat_code;
					state.signals[j].is_held = true;
					if ( found_signal != none ) {
						state.signals[j].held_for = previous_states[i].signals[found_signal].held_for+1;
						state.signals[j].was_held = true;
					} else state.signals[j].held_for = 1;
				} else { // Released
					var found_signal=none;
					if ( previous_states_len > i ) 
						for ( var m=0; m<array_length(previous_states[i].signals); m++ ) 
							if ( previous_states[i].signals[m].button == hat_code ) { found_signal=m; break; }
					if ( found_signal == none or (previous_states[i].signals[found_signal].was_held and !previous_states[i].signals[found_signal].is_held) ) { /* stop tracking it */ }
					else {
						var j=array_length(state.signals);
						state.signals[j]=__ICI.New_ICButtonState();
						state.signals[j].button=hat_code;
						state.signals[j].signal_index=hat_code;
						if ( found_signal != none ) {
							state.signals[j].held_for = previous_states[i].signals[found_signal].held_for;
							state.signals[j].was_held = true;
						} else state.signals[j].held_for = 1;
					}
				}
				hat_code++;
			}
			for ( var k=0; k<__INPUTCANDY.devices[i].axis_count; k++ ) state.axis[k]=gamepad_axis_value(state.slot_id,k);
			for ( var k=0; k<__INPUTCANDY.devices[i].button_count; k++ ) state.buttons[k]=gamepad_button_value(state.slot_id,k);
			for ( var k=__FIRST_GAMEPAD_SIGNAL; k<__LAST_GAMEPAD_SIGNAL_PLUS_1; k++ ) {
				var j=array_length(state.signals);
				if ( gamepad_button_check_pressed(state.slot_id,__INPUTCANDY.signals[k].deviceCode) ) {
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=__INPUTCANDY.signals[k].code;
					state.signals[j].signal_index=k;
					state.signals[j].is_held = true;
					state.signals[j].held_for = 1;
				} else if ( gamepad_button_check_released(state.slot_id,__INPUTCANDY.signals[k].deviceCode) ) {
					var found_signal=none;
					if ( previous_states_len > i ) for ( var m=0; m<array_length(previous_states[i].signals); m++ ) if ( previous_states[i].signals[m].button == __INPUTCANDY.signals[k].code ) {	found_signal=m;	break; }
					var j=array_length(state.signals);
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=__INPUTCANDY.signals[k].code;
					state.signals[j].signal_index=k;
					state.signals[j].was_held = true;
					if ( found_signal != none ) state.signals[j].held_for = previous_states[i].signals[found_signal].held_for+1;
					else state.signals[j].held_for = 1;
				} else if ( gamepad_button_check(state.slot_id,__INPUTCANDY.signals[k].deviceCode) ) {
					var found_signal=none;
					if ( previous_states_len > i ) for ( var m=0; m<array_length(previous_states[i].signals); m++ ) if ( previous_states[i].signals[m].button == __INPUTCANDY.signals[k].code ) {	found_signal=m;	break; }
					var j=array_length(state.signals);
					state.signals[j]=__ICI.New_ICButtonState();
					state.signals[j].button=__INPUTCANDY.signals[k].code;
					state.signals[j].signal_index=k;
					state.signals[j].is_held = true;
					state.signals[j].was_held = true;
					if ( found_signal != none ) state.signals[j].held_for = previous_states[i].signals[found_signal].held_for+1;
					else state.signals[j].held_for = 1;
				} 
			}
			__INPUTCANDY.states[array_length(__INPUTCANDY.states)]=state;
		}
	},
	
	
	//// PLAYERS
	New_ICPlayer: function () {
		return {
			settings: none,
			device: none,
			active: false,    // It's up to you to maintain this.  Set to true once a player is "in the game", and false once they are "out of the game"
			data: {}          // This is left here so you can add additional values yourself to a player, like if they are on a high score screen, or in character select mode, etc.
		};
	},	
	
	//// BINDING
	New_ICBinding: function() {
		return {
			action: none,
			button_id: none
		};
	},
	New_ICSetup: function() {
		return {
			player_index: none,
			settings_index: none,
			deviceType: ICDeviceType_nothing
		};
	},
	New_ICSettings: function () {
		return {
			autodetect_device: true,
			use_keyboard_mouse: false,
			use_gamepad: false,
			mappings: [],
		};
	},
	New_ICAction: function () {
		return {
			name: "New Action",
			group: "None",
			index: none,
			enabled: true
		};
	},
	New_ICDevice: function () {
		return {
			index: none,
			type: ICDeviceType_nothing,
			name: "Unnamed",
			slot_id: none,
			SDL_Mapping: "None"
		};
	},
	New_ICButtonActivity: function () {
		return {
			button_id: none,
			held_for: 0,
		};
	},
	New_ICNetwork: function() {
		return {
			peers: [],
			hosting: true
		};
	},

	// SDL Game Controller DB support
	// Will attempt to load the latest SDL text from a remote server
	Initiate_Get_SDL_GameControllerDB_FromWeb: function () {
		return http_get("https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt");
	},
	// Call this in the Async Event
	Async_Event_Get_SDL_GameControllerDB_FromWeb: function () {
		if (ds_map_find_value(async_load, "id") == get) {
		   if ds_map_find_value(async_load, "status") == 0 {
		      var r_str = ds_map_find_value(async_load, "result");
			  if ( string_length(r_str) > 1000 ) global.SDL_GameControllerDB = Process_SDL_GameControllerDB(r_str);	  
		   } else {
		   }
		 }
	}	 
 };	 
}
