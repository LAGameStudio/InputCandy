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
function Init_InputCandy_Advanced( bootstrap ) { __Private_Init_InputCandy(bootstrap); }

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


// The following functions map the internal object methods to externalized IC_* functions.
// They are here for convenience and to emphasize commonly used entry points to InputCandy.
// This can help remind you of the parameters, since GMS 2.3.1.542 doesn't autofill the
// parameters for object methods.  Some of them add complexity, so avoiding them is also
// a good idea, but use as reference.  (Use IC_Fun... then change to __IC.Fun)

function IC_Step() { __IC.Step(); }
function IC_ClearActions() { __IC.ClearActions(); }

// Returns an empty action struct you can modify, then push in.
function IC_NewAction() { return __ICI.New_ICAction(); }
function IC_ActionPush( action_in ) { return __IC.ActionPush( action_in ); }

function IC_Action_ext( n, g, gp, gpcombo, kb, kcombo, m, mcombo, kmcombo, UDLR, angled, held_s, flimit, on_rel, enabled, forbid ) {
 return __IC.Action_ext( n, g, gp, gpcombo, kb, kcombo, m, mcombo, kmcombo, UDLR, angled, held_s, flimit, on_rel, enabled, forbid );
}

function IC_GetAction( action_name ) {
	if ( argument_count > 1 ) return __IC.GetAction(action_name,argument1);
	else return __IC.GetAction(action_name);
}

function IC_Match( player_number, action_index ) { return __IC.Match( player_number, action_index ); }

function IC_Action( verb_string, default_gamepad, default_keyboard /*mouse, group, is_directional, requires_angle, enabled*/ ) {
 var mouse=none;
 var group="";
 var is_directional=false;
 var requires_angle=false;
 var enabled=false;
 if ( argument_count >= 4 ) mouse=argument[3];
 if ( argument_count >= 5 ) group=argument[4];
 if ( argument_count >= 6 ) is_directional=argument[5];
 if ( argument_count >= 7 ) requires_angle=argument[6];
 if ( argument_count >= 8 ) enabled=argument[7];
 return __IC.Action( verb_string, default_gamepad, default_keyboard, mouse, group, is_directional, requires_angle, enabled );	
}




////////// enumerations and global macros

#macro none -4
#macro unknown -123456789

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

#macro IC_absolute_minimum_deadzone 0.05

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
#macro IC_numpad_add 65 /* numpad + */
#macro IC_numpad_decimal 66 /* numpad . */
#macro IC_f1 67
#macro IC_f2 68
#macro IC_f3 69
#macro IC_f4 70
#macro IC_f5 71
#macro IC_f6 72
#macro IC_f7 73
#macro IC_f8 74
#macro IC_f9 75
#macro IC_f10 76
#macro IC_f11 77
#macro IC_f12 78
#macro IC_key_A 79
#macro IC_key_B 80
#macro IC_key_C 81
#macro IC_key_D 82
#macro IC_key_E 83
#macro IC_key_F 84
#macro IC_key_G 85
#macro IC_key_H 86
#macro IC_key_I 87
#macro IC_key_J 88
#macro IC_key_K 89
#macro IC_key_L 90
#macro IC_key_M 91
#macro IC_key_N 92
#macro IC_key_O 93
#macro IC_key_P 94
#macro IC_key_Q 95
#macro IC_key_R 96
#macro IC_key_S 97
#macro IC_key_T 98
#macro IC_key_U 99
#macro IC_key_V 100
#macro IC_key_W 101
#macro IC_key_X 102
#macro IC_key_Y 103
#macro IC_key_Z 104
#macro IC_key_0 105
#macro IC_key_1 106
#macro IC_key_2 107
#macro IC_key_3 108
#macro IC_key_4 109
#macro IC_key_5 110
#macro IC_key_6 111
#macro IC_key_7 112
#macro IC_key_8 113
#macro IC_key_9 114
#macro IC_key_backtick 115
#macro IC_key_comma 116
#macro IC_key_period 117
#macro IC_key_slash 118
#macro IC_key_backslash 119
#macro IC_key_minus 120
#macro IC_key_equals 121
#macro IC_key_lbracket 122
#macro IC_key_rbracket 123
#macro IC_key_semi 124
#macro IC_key_apostrophe 125
#macro IC_enter 126
#macro IC_space 127
#macro IC_key_escape 128
#macro IC_hat0_U 129
#macro IC_hat0_D 130
#macro IC_hat0_L 131
#macro IC_hat0_R 132
#macro IC_hat1_U 133
#macro IC_hat1_D 134
#macro IC_hat1_L 135
#macro IC_hat1_R 136
#macro IC_hat2_U 137
#macro IC_hat2_D 138
#macro IC_hat2_L 139
#macro IC_hat2_R 140
#macro IC_hat3_U 141
#macro IC_hat3_D 142
#macro IC_hat3_L 143
#macro IC_hat3_R 144
#macro IC_hat4_U 145
#macro IC_hat4_D 146
#macro IC_hat4_L 147
#macro IC_hat4_R 148

#macro IC_MAX_SIGNAL 148

////// Action pad indications.  A special category of action.

/* 
  Unlike buttons, a single signal, Axis, Hats and DPads are different.
  
  Actions that are for movement (usually) but may be used
  with secondary movement (aiming a turret for example), the user may want
  to swap Axis 0 for Axis 1, or Hat 1 for the Dpad
   */

// Directional pad.  Controllers tend to have 1 of these. LRUD
#macro IC_dpad 200

// Hats are a strange hybrid between Dpad and simply an array of 4 buttons.  LRUD usually
// Sometimes "Hats" are the joystick itself.  Hats can also be thumb buttons.
// Hats can also be unidirectional (up/down)
#macro IC_hat0 300
#macro IC_hat1 301
#macro IC_hat2 302
#macro IC_hat3 303
#macro IC_hat4 304
#macro IC_hat5 305
#macro IC_hat6 306
#macro IC_hat7 307
#macro IC_hat8 308
#macro IC_hat9 309


// Axis sticks are usually "horizontal and vertical" 0-1, where 0.5, 0.5 would mean "up right"
// The Classic Controller "Twist" on the Atari is only horizontal and is a special case.
// Axis sticks can also be used to define a slider control on some specialty joysticks.
// You can convert an Axis H/V value into an angle-of-direction with point_direction or __IC.AxisToAngle
// Axis values can also be converted into 4-directional indicators similar to DPads and Hats
#macro IC_axis0 400
#macro IC_axis1 401
#macro IC_axis2 402
#macro IC_axis3 403
#macro IC_axis4 404
#macro IC_axis5 405
#macro IC_axis6 406
#macro IC_axis7 407
#macro IC_axis8 408
#macro IC_axis9 409

/// STICKS, a stick is two axis used in tandem to create an analog thumbstick.  Since we support 10 axis, we support 100 sticks.

// IC_stick_XY, where X is the left-right axis and Y is the up-down axis


#macro IC_stick_01 410
#macro IC_stick_02 411
#macro IC_stick_03 412
#macro IC_stick_04 413
#macro IC_stick_05 414
#macro IC_stick_06 415
#macro IC_stick_07 416
#macro IC_stick_08 417
#macro IC_stick_09 418

#macro IC_stick_10 419
#macro IC_stick_12 420
#macro IC_stick_13 421
#macro IC_stick_14 422
#macro IC_stick_15 423
#macro IC_stick_16 424
#macro IC_stick_17 425
#macro IC_stick_18 426
#macro IC_stick_19 427

#macro IC_stick_20 428
#macro IC_stick_21 429
#macro IC_stick_23 430
#macro IC_stick_24 431
#macro IC_stick_25 432
#macro IC_stick_26 433
#macro IC_stick_27 434
#macro IC_stick_28 435
#macro IC_stick_29 436

#macro IC_stick_30 437
#macro IC_stick_31 438
#macro IC_stick_32 439
#macro IC_stick_34 440
#macro IC_stick_35 441
#macro IC_stick_36 442
#macro IC_stick_37 443
#macro IC_stick_38 444
#macro IC_stick_39 445

#macro IC_stick_40 446
#macro IC_stick_41 447
#macro IC_stick_42 448
#macro IC_stick_43 449
#macro IC_stick_45 450
#macro IC_stick_46 451
#macro IC_stick_47 452
#macro IC_stick_48 453
#macro IC_stick_49 454

#macro IC_stick_50 455
#macro IC_stick_51 456
#macro IC_stick_52 457
#macro IC_stick_53 458
#macro IC_stick_54 459
#macro IC_stick_56 460
#macro IC_stick_57 461
#macro IC_stick_58 462
#macro IC_stick_59 463

#macro IC_stick_60 464
#macro IC_stick_61 465
#macro IC_stick_62 466
#macro IC_stick_63 467
#macro IC_stick_64 468
#macro IC_stick_65 469
#macro IC_stick_67 470
#macro IC_stick_68 471
#macro IC_stick_69 472

#macro IC_stick_70 473
#macro IC_stick_71 474
#macro IC_stick_72 475
#macro IC_stick_73 476
#macro IC_stick_74 477
#macro IC_stick_75 478
#macro IC_stick_76 479
#macro IC_stick_78 480
#macro IC_stick_79 481

#macro IC_stick_80 482
#macro IC_stick_81 483
#macro IC_stick_82 484
#macro IC_stick_83 485
#macro IC_stick_84 486
#macro IC_stick_85 487
#macro IC_stick_86 488
#macro IC_stick_87 489
#macro IC_stick_89 490

#macro IC_stick_90 491
#macro IC_stick_91 492
#macro IC_stick_92 493
#macro IC_stick_93 494
#macro IC_stick_94 495
#macro IC_stick_95 496
#macro IC_stick_96 497
#macro IC_stick_97 498
#macro IC_stick_98 499

#macro IC_stick_left IC_stick_01
#macro IC_stick_right IC_stick_23

/// BUTTONS

#macro IC_btn0   500
#macro IC_btn1   501
#macro IC_btn2   502
#macro IC_btn3   503
#macro IC_btn4   504
#macro IC_btn5   505
#macro IC_btn6   506
#macro IC_btn7   507
#macro IC_btn8   508
#macro IC_btn9   509
#macro IC_btn10  510
#macro IC_btn11  511
#macro IC_btn12  512
#macro IC_btn13  513
#macro IC_btn14  514
#macro IC_btn15  515
#macro IC_btn16  516
#macro IC_btn17  517
#macro IC_btn18  518
#macro IC_btn19  519
#macro IC_btn20  520
#macro IC_btn21  521
#macro IC_btn22  522
#macro IC_btn23  523
#macro IC_btn24  524
#macro IC_btn25  525
#macro IC_btn26  526
#macro IC_btn27  527
#macro IC_btn28  528
#macro IC_btn29  529
#macro IC_btn30  530
#macro IC_btn31  531
#macro IC_btn32  532
#macro IC_btn33  533
#macro IC_btn34  534
#macro IC_btn35  535
#macro IC_btn36  536
#macro IC_btn37  537
#macro IC_btn38  538
#macro IC_btn39  539

// Arrow keys, a movement option
#macro IC_arrows 600
#macro IC_wasd   601
#macro IC_numpad 602

// Mouse movement.  Not used but could be.
/*
#macro IC_mouse_move 601
#macro IC_mouse_move_as_directional 602
#macro IC_mouse_trackball 603
*/


#macro __FIRST_GAMEPAD_SIGNAL 6
#macro __LAST_GAMEPAD_SIGNAL_PLUS_1 24
#macro __FIRST_MOUSE_SIGNAL 24
#macro __LAST_MOUSE_SIGNAL_PLUS_1 28
#macro __FIRST_KEYBOARD_SIGNAL 29
#macro __LAST_KEYBOARD_SIGNAL_PLUS_1 128

#macro ICKeyboardMethod_none 0
#macro ICKeyboardMethod_keycheck 1
#macro ICKeyboardMethod_keycheck_direct 2
#macro ICKeyboardMethod_ord 3
#macro ICKeyboardMethod_lastkey 4

// Types of activities involving buttons
#macro ICButton_released 0
#macro ICButton_held 1
#macro ICButton_pressed 2

// Called "once" to initialize everything.

function __Private_Init_InputCandy( bootstrap ) {
	
global.SDLDB_Entries=0;
global.SDLDB=[];

global._INPUTCANDY_DEFAULTS_ = {
 //// Global Settings ////
 ready: false,                            // Has IC been initialized?
 steps: unknown,                          // During initialization, steps is set to 0.  This number increases until we reach a certain threshold, and it is used to delay aspects of "setup detection" until device polling is complete (it is not a frame counter)
 max_players: 8,                          // Default value for SetMaxPlayers()
 player_using_keyboard_mouse: 0,          // Player index of the player using the keyboard and mouse
 allow_multibutton_capture: true,         // Allows players to assign multi-button combos to a single action, set to false for simplicity
 allow_keyboard_mouse: true,              // If the platform supports it, setting this true will use keyboard_and_mouse as an input device (false = hide on consoles w/o keyboard)
 allow_SDL_remapping: false,
 keyboard_layout: ICKeyboardLayout_qwerty,   // Changing to Azerty or Qwertz provides a sorta-remapping for keyboards, but there isn't a good way to detect what keyboard
 skip_simplified_axis: false,             // Set this value to true to stop IC from registering simplified axis movements.
 use_network: false,                      // Turn this on if you are going to be using network transmits
 settings_filename: "inputcandy.settings.json",      // Where player-defined settings are saved.
 setup_filename:  "inputcandy.controller.setup.json",         // This file is saved and attempts to remember which settings go with which player and which device, and which SDL remappings are desired
 //// External and Internal interface objects
 interface: New_InputCandy(),             // Public - the programmer interface used in your game.  All you need to know.
 internal: New_InputCandy_Private(),      // Functions used internally, generally not to be called, use interface instead, "private"
 //// Device, player, etc., states
 actions: [],                             // A list of Designer-defined actions ("verbs"), set by the interface
 devices: [],                             // A list of detected devices and their capabilities and remappings
 states: [],                              // A list of device states detected each frame that correspond in index to their associated device
 keys: [],                                // Keyboard key states
 mouseStates: [],                         // Mouse button states
 mouse: { x: none, y: none, left: false, middle: false, right: false, up: false, down: false },
 wasMouse: { x: none, y: none, left: false, middle: false, right: false, up: false, down: false },
 previous_devices: [],                    // A list of previous devices known about particular slots but not currently connected.  Init() establishes this as a stack. TODO
 signals: [],                             // Master collection of signals from all device types supported.
 players: [],                             // A list of player "slots", active setting info, and their status and device association, device state
 settings: [],                            // List of "stored" and associatable settings
 setup: none,				              // Holds on to previous sessions where players have been associated with devices
 network: {},
 platform: {},                            // Platform information acquired from GML
 //// Events that can be overridden: ////
 // Set this to a different function to trigger your own custom reaction to this event.
 e_controller_connected:    function( device_index, deviceInfo ) { show_debug_message("Controller connected! Device ID "+int(device_index)+" "+json_stringify(deviceInfo)); },
 // Set this to a different function to trigger your own custom reaction to this event.
 e_controller_disconnected: function( old_device_index, deviceInfo ) { show_debug_message("Controller disconnected! Device ID was "+int(old_device_index)+" "+json_stringify(deviceInfo)); },
 // Default action for saving the settings file (sandboxed on most systems, only change if you need to)
 e_save_file:      function( filename, json_data ) { string_as_file( filename, json_stringify(json_data) ); },
 e_load_file:      function( filename, default_json ) { if ( !file_exists(filename) ) return default_json; else return json_parse(file_as_string( filename )); },
 // I've removed this since it's best if you tie it into your game the way you want to.  You can simply detect signals and filter them from players who are inactive yourself.
 // What to do when a player wants to join.  This is useful if you wish for players to become active at any time, but can be handled another way
 // e_inactive_player_pressed_start:     function( player_number ) {} //show_debug_message("Player wants to start! "+string_format(player_number,1,0)); }
};

// This is the global variable where the persistent state of InputCandy is stored.   __IC.interface references this global profile.
__INPUTCANDY = global._INPUTCANDY_DEFAULTS_;

__INPUTCANDY.platform = __ICI.GetPlatformSpecifics();

__INPUTCANDY.signals = [
 {	index:0,    code: IC_none,		     name: "None",  deviceType: ICDeviceType_any },
 {	index:1,    code: IC_anykey,	     name: "Any",   deviceType: ICDeviceType_any },
 {	index:2,    code: IC_left=0,	     name: "Left",  deviceType: ICDeviceType_any },
 {	index:3,    code: IC_right,		     name: "Right", deviceType: ICDeviceType_any },
 {	index:4,    code: IC_up,		     name: "Up",    deviceType: ICDeviceType_any },
 {	index:5,    code: IC_down,		     name: "Down",  deviceType: ICDeviceType_any },
 {	index:6,    code: IC_A,			     name: "A",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face1 }, //__FIRST_GAMEPAD_SIGNAL
 {	index:7,    code: IC_B,			     name: "B",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face2 },
 {	index:8,    code: IC_AandB,		     name: "AandB",          deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:9,    code: IC_X,			     name: "X",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face3 },
 {	index:10,   code: IC_Y,			     name: "Y",              deviceType: ICDeviceType_gamepad, deviceCode: gp_face4 },
 {	index:11,   code: IC_XandY,		     name: "XandY",          deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:12,   code: IC_start,		     name: "Start",          deviceType: ICDeviceType_gamepad, deviceCode: gp_start },
 {	index:13,   code: IC_back_select,    name: "Back/Select",    deviceType: ICDeviceType_gamepad, deviceCode: gp_select },
 {	index:14,   code: IC_Ltrigger,	     name: "Left Trigger",   deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderlb },
 {	index:15,   code: IC_Rtrigger,	     name: "Right Trigger",  deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderrb },
 {	index:16,   code: IC_Lshoulder,	     name: "Left Shoulder",  deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderl },
 {	index:17,   code: IC_Rshoulder,	     name: "Right Shoulder", deviceType: ICDeviceType_gamepad, deviceCode: gp_shoulderr },
 {	index:18,   code: IC_Lstick,	     name: "Left Stick",     deviceType: ICDeviceType_gamepad, deviceCode: gp_stickl },
 {	index:19,   code: IC_Rstick,	     name: "Right Stick",    deviceType: ICDeviceType_gamepad, deviceCode: gp_stickr },
 {	index:20,   code: IC_padu,		     name: "Pad Up",         deviceType: ICDeviceType_gamepad, deviceCode: gp_padu },
 {	index:21,   code: IC_padd,		     name: "Pad Down",       deviceType: ICDeviceType_gamepad, deviceCode: gp_padd },
 {	index:22,   code: IC_padl,		     name: "Pad Left",       deviceType: ICDeviceType_gamepad, deviceCode: gp_padl },
 {	index:23,   code: IC_padr,		     name: "Pad Right",      deviceType: ICDeviceType_gamepad, deviceCode: gp_padr },
 {  index:24,   code: IC_mouse_left,     name: "LMB",            deviceType: ICDeviceType_mouse }, //__FIRST_MOUSE_SIGNAL
 {  index:25,   code: IC_mouse_right,	 name: "RMB",            deviceType: ICDeviceType_mouse },
 {  index:26,   code: IC_mouse_middle,	 name: "MMB",            deviceType: ICDeviceType_mouse },
 {  index:27,   code: IC_mouse_scrollup, name: "Scroll Up",      deviceType: ICDeviceType_mouse },
 {  index:28,   code: IC_mouse_scrolldown,  name: "Scroll Down", deviceType: ICDeviceType_mouse },
 {	index:29,   code: IC_key_arrow_L,	 name: "Left Arrow",     azerty_name: "Left Arrow",  qwertz_name:"Left Arrow",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_left },
 {	index:30,   code: IC_key_arrow_R,	 name: "Right Arrow",    azerty_name: "Right Arrow", qwertz_name:"Right Arrow", deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_right  },
 {	index:31,   code: IC_key_arrow_U,	 name: "Up Arrow",       azerty_name: "Up Arrow",    qwertz_name:"Up Arrow",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_up },
 {	index:32,   code: IC_key_arrow_D,	 name: "Down Arrow",     azerty_name: "Down Arrow",  qwertz_name:"Down Arrow",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_down },
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
 {	index:62,   code: IC_numpad_multiply,name: "Num *",   azerty_name: "Num *",   qwertz_name: "Num *",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_multiply },
 {	index:63,   code: IC_numpad_divide,  name: "Num /",   azerty_name: "Num /",   qwertz_name: "Num /",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_divide },
 {	index:64,   code: IC_numpad_subtract,name: "Num -",   azerty_name: "Num -",   qwertz_name: "Num -",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_subtract },
 {	index:65,   code: IC_numpad_add,     name: "Num +",   azerty_name: "Num +",   qwertz_name: "Num +",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_add },
 {	index:66,   code: IC_numpad_decimal, name: "Num .",   azerty_name: "Num .",   qwertz_name: "Num .",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_decimal },
 {	index:67,   code: IC_f1,		     name: "F1",      azerty_name: "F1",      qwertz_name: "F1",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f1 },
 {	index:68,   code: IC_f2,		     name: "F2",      azerty_name: "F2",      qwertz_name: "F2",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f2 },
 {	index:69,   code: IC_f3,		     name: "F3",      azerty_name: "F3",      qwertz_name: "F3",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f3 },
 {	index:70,   code: IC_f4,		     name: "F4",      azerty_name: "F4",      qwertz_name: "F4",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f4 },
 {	index:71,   code: IC_f5,		     name: "F5",      azerty_name: "F5",      qwertz_name: "F5",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f5 },
 {	index:72,   code: IC_f6,		     name: "F6",      azerty_name: "F6",      qwertz_name: "F6",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f6 },
 {	index:73,   code: IC_f7,		     name: "F7",      azerty_name: "F7",      qwertz_name: "F7",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f7 },
 {	index:74,   code: IC_f8,		     name: "F8",      azerty_name: "F8",      qwertz_name: "F8",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f8 },
 {	index:75,   code: IC_f9,		     name: "F9",      azerty_name: "F9",      qwertz_name: "F9",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f9 },
 {	index:76,   code: IC_f10,		     name: "F10",     azerty_name: "F10",     qwertz_name: "F10",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f10 },
 {	index:77,   code: IC_f11,		     name: "F11",     azerty_name: "F11",     qwertz_name: "F11",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f11 },
 {	index:78,   code: IC_f12,		     name: "F12",     azerty_name: "F12",     qwertz_name: "F12",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_f12 },
 {	index:79,   code: IC_key_A,		     name: "Key A",   azerty_name: "Key Q",   qwertz_name: "Key A",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "A" },
 {	index:80,   code: IC_key_B,		     name: "Key B",   azerty_name: "Key B",   qwertz_name: "Key B",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "B" },
 {	index:81,   code: IC_key_C,		     name: "Key C",   azerty_name: "Key C",   qwertz_name: "Key C",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "C" },
 {	index:82,   code: IC_key_D,		     name: "Key D",   azerty_name: "Key D",   qwertz_name: "Key D",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "D" },
 {	index:83,   code: IC_key_E,		     name: "Key E",   azerty_name: "Key E",   qwertz_name: "Key E",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "E" },
 {	index:84,   code: IC_key_F,		     name: "Key F",   azerty_name: "Key F",   qwertz_name: "Key F",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "F" },
 {	index:85,   code: IC_key_G,		     name: "Key G",   azerty_name: "Key G",   qwertz_name: "Key G",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "G" },
 {	index:86,   code: IC_key_H,		     name: "Key H",   azerty_name: "Key H",   qwertz_name: "Key H",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "H" },
 {	index:87,   code: IC_key_I,		     name: "Key I",   azerty_name: "Key I",   qwertz_name: "Key I",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "I" },
 {	index:88,   code: IC_key_J,		     name: "Key J",   azerty_name: "Key J",   qwertz_name: "Key J",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "J" },
 {	index:89,   code: IC_key_K,		     name: "Key K",   azerty_name: "Key K",   qwertz_name: "Key K",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "K" },
 {	index:90,   code: IC_key_L,		     name: "Key L",   azerty_name: "Key L",   qwertz_name: "Key L",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "L" },
 {	index:91,   code: IC_key_M,		     name: "Key M",   azerty_name: "Key M",   qwertz_name: "Key M",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "M" },
 {	index:92,   code: IC_key_N,		     name: "Key N",   azerty_name: "Key N",   qwertz_name: "Key N",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "N" },
 {	index:93,   code: IC_key_O,		     name: "Key O",   azerty_name: "Key O",   qwertz_name: "Key O",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "O" },
 {	index:94,   code: IC_key_P,		     name: "Key P",   azerty_name: "Key P",   qwertz_name: "Key P",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "P" },
 {	index:95,   code: IC_key_Q,		     name: "Key Q",   azerty_name: "Key A",   qwertz_name: "Key Q",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "Q" },
 {	index:96,   code: IC_key_R,		     name: "Key R",   azerty_name: "Key R",   qwertz_name: "Key R",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "R" },
 {	index:97,   code: IC_key_S,		     name: "Key S",   azerty_name: "Key S",   qwertz_name: "Key S",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "S" },
 {	index:98,   code: IC_key_T,		     name: "Key T",   azerty_name: "Key R",   qwertz_name: "Key T",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "T" },
 {	index:99,   code: IC_key_U,		     name: "Key U",   azerty_name: "Key U",   qwertz_name: "Key Y",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "U" },
 {	index:100,  code: IC_key_V,		     name: "Key V",   azerty_name: "Key V",   qwertz_name: "Key V",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "V" },
 {	index:101,  code: IC_key_W,		     name: "Key W",   azerty_name: "Key Z",   qwertz_name: "Key W",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "W" },
 {	index:102,  code: IC_key_X,		     name: "Key X",   azerty_name: "Key X",   qwertz_name: "Key X",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "X" },
 {	index:103,  code: IC_key_Y,		     name: "Key Y",   azerty_name: "Key Y",   qwertz_name: "Key Z",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "Y" },
 {	index:104,  code: IC_key_Z,		     name: "Key Z",   azerty_name: "Key W",   qwertz_name: "Key Y",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "Z" },
 {	index:105,  code: IC_key_0,		     name: "Key 0",   azerty_name: "Key 0",   qwertz_name: "Key 0",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "0" },
 {	index:106,  code: IC_key_1,		     name: "Key 1",   azerty_name: "Key 1",   qwertz_name: "Key 1",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "1" },
 {	index:107,  code: IC_key_2,		     name: "Key 2",   azerty_name: "Key 2",   qwertz_name: "Key 2",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "2" },
 {	index:108,  code: IC_key_3,		     name: "Key 3",   azerty_name: "Key 3",   qwertz_name: "Key 3",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "3" },
 {	index:109,  code: IC_key_4,		     name: "Key 4",   azerty_name: "Key 4",   qwertz_name: "Key 4",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "4" },
 {	index:110,  code: IC_key_5,		     name: "Key 5",   azerty_name: "Key 5",   qwertz_name: "Key 5",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "5" },
 {	index:111,  code: IC_key_6,		     name: "Key 6",   azerty_name: "Key 6",   qwertz_name: "Key 6",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "6" },
 {	index:112,  code: IC_key_7,		     name: "Key 7",   azerty_name: "Key 7",   qwertz_name: "Key 7",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "7" },
 {	index:113,  code: IC_key_8,		     name: "Key 8",   azerty_name: "Key 8",   qwertz_name: "Key 8",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "8" },
 {	index:114,  code: IC_key_9,		     name: "Key 9",   azerty_name: "Key 9",   qwertz_name: "Key 9",   deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_ord, keychar: "9" },
 {	index:115,  code: IC_key_backtick,	 name: "Backtick",      azerty_name: "Backtick",      qwertz_name:"Backtick",      deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "`" , shifted: "~" },
 {	index:116,  code: IC_key_comma,		 name: "Comma",         azerty_name: "Comma",         qwertz_name:"Comma",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "," , shifted: "<" },
 {	index:117,  code: IC_key_period,	 name: "Period",        azerty_name: "Period",        qwertz_name:"Period",        deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "." , shifted: ">" },
 {	index:118,  code: IC_key_slash,		 name: "Slash",         azerty_name: "Slash",         qwertz_name:"Slash",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "/" , shifted: "?" },
 {	index:119,  code: IC_key_backslash,  name: "Backslash",     azerty_name: "Backslash",     qwertz_name:"Backslash",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "\\", shifted: "|" },
 {	index:120,  code: IC_key_minus,		 name: "Minus",         azerty_name: "Minus",         qwertz_name:"Minus",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "-" , shifted: "_" },
 {	index:121,  code: IC_key_equals,	 name: "Equals",        azerty_name: "Equals",        qwertz_name:"Equals",        deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "=" , shifted: "+" },
 {	index:122,  code: IC_key_lbracket,	 name: "Left Bracket",  azerty_name: "Left Bracket",  qwertz_name:"Left Bracket",  deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "[" , shifted: "{" },
 {	index:123,  code: IC_key_rbracket,	 name: "Right Bracket", azerty_name: "Right Bracket", qwertz_name:"Right Bracket", deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "]" , shifted: "}" },
 {	index:124,  code: IC_key_semi,		 name: "Semicolon",     azerty_name: "Semicolon",     qwertz_name:"Semicolon",     deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: ";" , shifted: ":" },
 {	index:125,  code: IC_key_apostrophe, name: "Apostrophe",    azerty_name: "Apostrophe",    qwertz_name:"Apostrophe",    deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_lastkey, keychar: "'" , shifted: "\"" },
 {	index:126,  code: IC_enter,          name: "Enter",			azerty_name: "Enter",         qwertz_name:"Enter",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_enter  },
 {	index:127,  code: IC_space,          name: "Space",			azerty_name: "Space",         qwertz_name:"Space",         deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_space  },
 {	index:128,  code: IC_key_escape,     name: "Escape",		azerty_name: "Escape",        qwertz_name:"Escape",        deviceType: ICDeviceType_keyboard, keyboardMethod: ICKeyboardMethod_keycheck, keycode: vk_escape },
 {	index:129,  code: IC_hat0_U,		 name: "Hat0 Up",       deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:130,  code: IC_hat0_D,		 name: "Hat0 Down",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:131,  code: IC_hat0_L,		 name: "Hat0 Left",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:132,  code: IC_hat0_R,	     name: "Hat0 Right",	deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:133,  code: IC_hat1_U,		 name: "Hat1 Up",       deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:134,  code: IC_hat1_D,		 name: "Hat1 Down",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:135,  code: IC_hat1_L,		 name: "Hat1 Left",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:136,  code: IC_hat1_R,	     name: "Hat1 Right",	deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:137,  code: IC_hat2_U,		 name: "Hat2 Up",       deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:138,  code: IC_hat2_D,		 name: "Hat2 Down",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:139,  code: IC_hat2_L,		 name: "Hat2 Left",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:140,  code: IC_hat2_R,	     name: "Hat2 Right",	deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:141,  code: IC_hat3_U,		 name: "Hat3 Up",       deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:142,  code: IC_hat3_D,		 name: "Hat3 Down",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:143,  code: IC_hat3_L,		 name: "Hat3 Left",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:144,  code: IC_hat3_R,	     name: "Hat3 Right",	deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:145,  code: IC_hat4_U,		 name: "Hat4 Up",       deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:146,  code: IC_hat4_D,		 name: "Hat4 Down",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:147,  code: IC_hat4_L,		 name: "Hat4 Left",     deviceType: ICDeviceType_gamepad, deviceCode: none },
 {	index:148,  code: IC_hat4_R,	     name: "Hat4 Right",	deviceType: ICDeviceType_gamepad, deviceCode: none },
];

__INPUTCANDY.directionals=[
 { index:0,    code: IC_dpad,     name: "D-Pad",      deviceType: ICDeviceType_gamepad },
 { index:1,    code: IC_hat0,     name: "Hat0",       deviceType: ICDeviceType_gamepad },
 { index:2,    code: IC_hat1,     name: "Hat1",       deviceType: ICDeviceType_gamepad },
 { index:3,    code: IC_hat2,     name: "Hat2",       deviceType: ICDeviceType_gamepad },
 { index:4,    code: IC_hat3,     name: "Hat3",       deviceType: ICDeviceType_gamepad },
 { index:5,    code: IC_hat4,     name: "Hat4",       deviceType: ICDeviceType_gamepad },
 { index:6,    code: IC_hat5,     name: "Hat5",       deviceType: ICDeviceType_gamepad },
 { index:7,    code: IC_hat6,     name: "Hat6",       deviceType: ICDeviceType_gamepad },
 { index:8,    code: IC_hat7,     name: "Hat7",       deviceType: ICDeviceType_gamepad },
 { index:9,    code: IC_hat8,     name: "Hat8",       deviceType: ICDeviceType_gamepad },
 { index:10,   code: IC_hat9,     name: "Hat9",       deviceType: ICDeviceType_gamepad },
 { index:11,   code: IC_axis0,    name: "Axis0",      deviceType: ICDeviceType_gamepad },
 { index:12,   code: IC_axis1,    name: "Axis1",      deviceType: ICDeviceType_gamepad },
 { index:13,   code: IC_axis2,    name: "Axis2",      deviceType: ICDeviceType_gamepad },
 { index:14,   code: IC_axis3,    name: "Axis3",      deviceType: ICDeviceType_gamepad },
 { index:15,   code: IC_axis4,    name: "Axis4",      deviceType: ICDeviceType_gamepad },
 { index:16,   code: IC_axis5,    name: "Axis5",      deviceType: ICDeviceType_gamepad },
 { index:17,   code: IC_axis6,    name: "Axis6",      deviceType: ICDeviceType_gamepad },
 { index:18,   code: IC_axis7,    name: "Axis7",      deviceType: ICDeviceType_gamepad },
 { index:19,   code: IC_axis8,    name: "Axis8",      deviceType: ICDeviceType_gamepad },
 { index:20,   code: IC_axis9,    name: "Axis9",      deviceType: ICDeviceType_gamepad },
 { index:21,   code: IC_stick_01, name: "Stick 0+1",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 1 },
 { index:22,   code: IC_stick_02, name: "Stick 0+2",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 2 },
 { index:23,   code: IC_stick_03, name: "Stick 0+3",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 3 },
 { index:24,   code: IC_stick_04, name: "Stick 0+4",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 4 },
 { index:25,   code: IC_stick_05, name: "Stick 0+5",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 5 },
 { index:26,   code: IC_stick_06, name: "Stick 0+6",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 6 },
 { index:27,   code: IC_stick_07, name: "Stick 0+7",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 7 },
 { index:28,   code: IC_stick_08, name: "Stick 0+8",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 8 },
 { index:29,   code: IC_stick_09, name: "Stick 0+9",  deviceType: ICDeviceType_gamepad, stickH: 0, stickV: 9 },
 { index:30,   code: IC_stick_10, name: "Stick 1+0",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 0 },
 { index:31,   code: IC_stick_12, name: "Stick 1+2",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 2 },
 { index:32,   code: IC_stick_13, name: "Stick 1+3",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 3 },
 { index:33,   code: IC_stick_14, name: "Stick 1+4",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 4 },
 { index:34,   code: IC_stick_15, name: "Stick 1+5",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 5 },
 { index:35,   code: IC_stick_16, name: "Stick 1+6",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 6 },
 { index:36,   code: IC_stick_17, name: "Stick 1+7",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 7 },
 { index:37,   code: IC_stick_18, name: "Stick 1+8",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 8 },
 { index:38,   code: IC_stick_19, name: "Stick 1+9",  deviceType: ICDeviceType_gamepad, stickH: 1, stickV: 9 },
 { index:39,   code: IC_stick_20, name: "Stick 2+0",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 0 },
 { index:40,   code: IC_stick_21, name: "Stick 2+1",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 1 },
 { index:41,   code: IC_stick_23, name: "Stick 2+3",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 3 },
 { index:42,   code: IC_stick_24, name: "Stick 2+4",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 4 },
 { index:43,   code: IC_stick_25, name: "Stick 2+5",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 5 },
 { index:44,   code: IC_stick_26, name: "Stick 2+6",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 6 },
 { index:45,   code: IC_stick_27, name: "Stick 2+7",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 7 },
 { index:46,   code: IC_stick_28, name: "Stick 2+8",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 8 },
 { index:47,   code: IC_stick_29, name: "Stick 2+9",  deviceType: ICDeviceType_gamepad, stickH: 2, stickV: 9 },
 { index:48,   code: IC_stick_30, name: "Stick 3+0",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 0 },
 { index:49,   code: IC_stick_31, name: "Stick 3+1",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 1 },
 { index:50,   code: IC_stick_32, name: "Stick 3+2",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 2 },
 { index:51,   code: IC_stick_34, name: "Stick 3+4",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 4 },
 { index:52,   code: IC_stick_35, name: "Stick 3+5",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 5 },
 { index:53,   code: IC_stick_36, name: "Stick 3+6",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 6 },
 { index:54,   code: IC_stick_37, name: "Stick 3+7",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 7 },
 { index:55,   code: IC_stick_38, name: "Stick 3+8",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 8 },
 { index:56,   code: IC_stick_39, name: "Stick 3+9",  deviceType: ICDeviceType_gamepad, stickH: 3, stickV: 9 },
 { index:57,   code: IC_stick_40, name: "Stick 4+0",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 0 },
 { index:58,   code: IC_stick_41, name: "Stick 4+1",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 1 },
 { index:59,   code: IC_stick_42, name: "Stick 4+2",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 2 },
 { index:60,   code: IC_stick_43, name: "Stick 4+3",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 3 },
 { index:61,   code: IC_stick_45, name: "Stick 4+5",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 5 },
 { index:62,   code: IC_stick_46, name: "Stick 4+6",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 6 },
 { index:63,   code: IC_stick_47, name: "Stick 4+7",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 7 },
 { index:64,   code: IC_stick_48, name: "Stick 4+8",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 8 },
 { index:65,   code: IC_stick_49, name: "Stick 4+9",  deviceType: ICDeviceType_gamepad, stickH: 4, stickV: 9 },
 { index:66,   code: IC_stick_50, name: "Stick 5+0",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 0 },
 { index:67,   code: IC_stick_51, name: "Stick 5+1",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 1 },
 { index:68,   code: IC_stick_52, name: "Stick 5+2",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 2 },
 { index:69,   code: IC_stick_53, name: "Stick 5+3",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 3 },
 { index:70,   code: IC_stick_54, name: "Stick 5+4",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 4 },
 { index:71,   code: IC_stick_56, name: "Stick 5+6",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 6 },
 { index:72,   code: IC_stick_57, name: "Stick 5+7",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 7 },
 { index:73,   code: IC_stick_58, name: "Stick 5+8",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 8 },
 { index:74,   code: IC_stick_59, name: "Stick 5+9",  deviceType: ICDeviceType_gamepad, stickH: 5, stickV: 9 },
 { index:75,   code: IC_stick_60, name: "Stick 6+0",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 0 },
 { index:76,   code: IC_stick_61, name: "Stick 6+1",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 1 },
 { index:77,   code: IC_stick_62, name: "Stick 6+2",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 2 },
 { index:78,   code: IC_stick_63, name: "Stick 6+3",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 3 },
 { index:79,   code: IC_stick_64, name: "Stick 6+4",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 4 },
 { index:80,   code: IC_stick_65, name: "Stick 6+5",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 5 },
 { index:81,   code: IC_stick_67, name: "Stick 6+7",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 7 },
 { index:82,   code: IC_stick_68, name: "Stick 6+8",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 8 },
 { index:83,   code: IC_stick_69, name: "Stick 6+9",  deviceType: ICDeviceType_gamepad, stickH: 6, stickV: 9 },
 { index:84,   code: IC_stick_70, name: "Stick 7+0",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 0 },
 { index:85,   code: IC_stick_71, name: "Stick 7+1",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 1 },
 { index:86,   code: IC_stick_72, name: "Stick 7+2",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 2 },
 { index:87,   code: IC_stick_73, name: "Stick 7+3",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 3 },
 { index:88,   code: IC_stick_74, name: "Stick 7+4",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 4 },
 { index:89,   code: IC_stick_75, name: "Stick 7+5",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 5 },
 { index:90,   code: IC_stick_76, name: "Stick 7+6",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 6 },
 { index:91,   code: IC_stick_78, name: "Stick 7+8",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 8 },
 { index:92,   code: IC_stick_79, name: "Stick 7+9",  deviceType: ICDeviceType_gamepad, stickH: 7, stickV: 9 },
 { index:93,   code: IC_stick_80, name: "Stick 8+0",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 0 },
 { index:94,   code: IC_stick_81, name: "Stick 8+1",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 1 },
 { index:95,   code: IC_stick_82, name: "Stick 8+2",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 2 },
 { index:96,   code: IC_stick_83, name: "Stick 8+3",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 3 },
 { index:97,   code: IC_stick_84, name: "Stick 8+4",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 4 },
 { index:98,   code: IC_stick_85, name: "Stick 8+5",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 5 },
 { index:99,   code: IC_stick_86, name: "Stick 8+6",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 6 },
 { index:100,  code: IC_stick_87, name: "Stick 8+7",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 7 },
 { index:101,  code: IC_stick_89, name: "Stick 8+9",  deviceType: ICDeviceType_gamepad, stickH: 8, stickV: 9 },
 { index:102,  code: IC_stick_90, name: "Stick 9+0",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 0 },
 { index:103,  code: IC_stick_91, name: "Stick 9+1",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 1 },
 { index:104,  code: IC_stick_92, name: "Stick 9+2",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 2 },
 { index:105,  code: IC_stick_93, name: "Stick 9+3",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 3 },
 { index:106,  code: IC_stick_94, name: "Stick 9+4",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 4 },
 { index:107,  code: IC_stick_95, name: "Stick 9+5",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 5 },
 { index:108,  code: IC_stick_96, name: "Stick 9+6",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 6 },
 { index:109,  code: IC_stick_97, name: "Stick 9+7",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 7 },
 { index:110,  code: IC_stick_98, name: "Stick 9+8",  deviceType: ICDeviceType_gamepad, stickH: 9, stickV: 8 },
 { index:111,  code: IC_arrows,   name: "Arrow Keys", deviceType: ICDeviceType_keyboard, azerty_name: "Arrow Keys",  qwertz_name: "Arrow Keys"  },
 { index:112,  code: IC_wasd,     name: "WASD Keys",  deviceType: ICDeviceType_keyboard, azerty_name: "ZQSD Keys",   qwertz_name: "WASD Keys"   },
 { index:113,  code: IC_numpad,   name: "Numpad 2468",deviceType: ICDeviceType_keyboard, azerty_name: "Numpad 2468", qwertz_name: "Numpad 2468" }
];

__INPUTCANDY.SDL_GameControllerDB = [];

bootstrap.init();
__ICI.LoadSettings();

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
		ClearActions: function () { __INPUTCANDY.actions=[]; },
		// @description This function installs a new action.  You can call it with 3, but it can take up to 7 parameters:
		// verb_string - the name of your action you will look it up by
		// default_gamepad - this expects an IC_ button code, like IC_dpad_U, for gamepad default suggestion, IC_none otherwise/default
		// default_keyboard - this expects an IC_ button code, like IC_key_A, for gamepad default suggestion, IC_none otherwise/default
		// default_mouse   - IC_mouse_left, IC_mouse_right, IC_mouse_middle, IC_mouse_scrollup, IC_mouse_scrolldown or IC_none (default)
		// group - another string that groups actions together (optional)
		// is_directional - a true/false value indicating this is for a dpad, hat or axis (false by default)
		// requires_angle - a true/false value that further specifies we are expecting a vert/horiz axis to be used (false by default)
		// enabled - optional, a true/false (true is default) that starts this action as deactivated or activated
		// @returns integer index of new action from __INPUTCANDY.actions[] array
		Action: function ( verb_string, default_gamepad, default_keyboard ) {
			var a=__ICI.New_ICAction();
			a.name=verb_string;
			a.gamepad=default_gamepad;
			a.keyboard=default_keyboard;
			if ( argument_count >= 4 ) a.mouse=argument[3];
			if ( argument_count >= 5 ) a.group=argument[4];
			if ( argument_count >= 6 ) a.is_directional=argument[5];
			if ( argument_count >= 7 ) a.requires_angle=argument[6];
			if ( argument_count >= 8 ) a.enabled=argument[7];
			a.index = array_length(__INPUTCANDY.actions);
			__INPUTCANDY.actions[a.index]=a;
			return a.index;
		},
		ActionPush: function ( in ) {
			var index=array_length(__INPUTCANDY.actions);
			__INPUTCANDY.actions[index]={
				index:index,
				name:in.name,
				group:in.group,
				gamepad:in.gamepad,
				gamepad_combo:in.gamepad_combo,
				keyboard:in.keyboard,
				keyboard_combo:in.keyboard_combo,
				mouse:in.mouse,
				mouse_combo:in.mouse_combo,
				mouse_keyboard_combo:in.mouse_keyboard_combo,
				is_directional:in.is_directional,
				requires_angle:in.requires_angle,
				held_for_seconds:in.held_for_seconds,
				fire_limit:in.fire_limit,
				released:in.released,
				enabled:in.enabled,
				forbid_rebinding:in.forbid_rebinding
			};
			return index;
		},
		Action_ext: function ( name, group,	gamepad, gamepad_combo, keyboard, keyboard_combo, mouse, mouse_combo, mouse_keyboard_combo, is_directional,
			requires_angle,	held_for_seconds, fire_limit, released, enabled, forbid_rebinding ) {
			var index=array_length(__INPUTCANDY.actions);
			__INPUTCANDY.actions[index]={
				index:index,
				name:name,
				group:group,
				gamepad:gamepad,
				gamepad_combo:gamepad_combo,
				keyboard:keyboard,
				keyboard_combo:keyboard_combo,
				mouse:mouse,
				mouse_combo:mouse_combo,
				mouse_keyboard_combo:mouse_keyboard_combo,
				is_directional:is_directional,
				requires_angle:requires_angle,
				held_for_seconds:held_for_seconds,
				fire_limit:fire_limit,
				released:released,
				enabled:enabled,
				forbid_rebinding:forbid_rebinding
			};
			return index;
		},
		// Alternatively, you can install an action list from an array of struct source
		// using the template for actions defined in New_ICAction()
		Actions: function ( action_list ) {
			var len=array_length(action_list);
			for ( var i=0; i<len; i++ ) {
				__IC.Action( action_list[i].name, action_list[i].group );
			}
		},
		// Toggles the enabled value to true
		ActivateAction: function ( action_index ) { __INPUTCANDY.actions[action_index].enabled=true; },
		// Toggles the enabled value to false
		DeactivateAction: function ( action_index ) { __INPUTCANDY.actions[action_index].enabled=false;	},
		// Asks if the action is enabled
		IsActionEnabled: function ( action_index ) { return __INPUTCANDY.actions[action_index].enabled; },
		// Deactivates a group of actions and returns their indexes
		DeactivateGroup: function ( group_name ) {
			var grouped=__IC.GetActionGroup( group_name );
			var len=array_length(grouped);
			for ( var i=0; i<len; i++ ) __INPUTCANDY.actions[grouped[i]].enabled=false;
			return grouped;
		},
		// Activates a group of actions and returns their indexes
		ActivateGroup: function ( group_name ) {
			var grouped=__IC.GetActionGroup( group_name );
			var len=array_length(grouped);
			for ( var i=0; i<len; i++ ) __INPUTCANDY.actions[grouped[i]].enabled=false;
			return grouped;
		},
		// Get Action's index from list by name, if you pass a second argument, it requires it to be in the specified group.
		GetAction: function ( name /*, group*/ ) {
			var len=array_length(__INPUTCANDY.actions);
			if ( argument_count > 1 ) {
				for ( var i=0; i<len; i++ )	if ( __INPUTCANDY.actions[i].name == name and __INPUTCANDY.actions[i].group == argument1 ) return i;
			} else {
				for ( var i=0; i<len; i++ ) if ( __INPUTCANDY.actions[i].name == name ) return i;
			}
			return none;
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
		// Checks a specific player&device&binding pairing for presence of a provided action currently
		ActionCheck: function ( player_number, action /*, group*/ ) {
			var index;
			if ( argument_count > 2 ) index= __IC.GetAction(action);
			else index= __IC.GetAction(action,argument1);
			if ( index == none ) {
				show_debug_message("Invalid action: "+action+" Group: "+argument1);
				return false;
			}
			return __IC.Check( player_number, index );
		},
		// Checks that an action was recently stopped ("released")
		ActionCheckReleased: function ( player_number, action /*, group*/ ) {
			var index;
			if ( argument_count > 2 ) index= __IC.GetAction(action);
			else index= __IC.GetAction(action,argument1);
			if ( index == none ) {
				show_debug_message("Invalid action: "+action+" Group: "+argument1);
				return false;
			}
			return __IC.CheckReleased( player_number, index );
		},
		// Checks _any_ player for an action
		ActionCheckAny: function ( action /*, group*/ ) {
			var index;
			if ( argument_count > 1 ) index= __IC.GetAction(action);
			else index= __IC.GetAction(action,argument1);
			if ( index == none ) {
				show_debug_message("Invalid action: "+action+" Group: "+argument1);
				return false;
			}
			return __IC.CheckAny( index );
		},
		// Checks _any_ player for an action was recently stopped ("released")
		ActionCheckReleasedAny: function ( action /*, group*/ ) {
			var index;
			if ( argument_count > 1 ) index= __IC.GetAction(action);
			else index= __IC.GetAction(action,argument1);
			if ( index == none ) {
				show_debug_message("Invalid action: "+action+" Group: "+argument1);
				return false;
			}
			return __IC.CheckReleasedAny( index );
		},
		// Checks a specific player&device&binding pairing for presence of a provided action currently
		Match: function ( player_number, action_index ) {
			var action=__INPUTCANDY.actions[action_index];
			if ( !action.enabled ) return none;
			var player_index=__IC.GetPlayerIndex(player_number);
			var binding=unknown;
			if ( action.forbid_rebinding ) binding=none;
			else if ( argument_count > 2 ) binding=argument2;
			if ( action.is_directional ) {
				// The binding just permits choosing a different source for this data.
				return __ICI.MatchDirectional(player_index,action_index,action);
			}
			if ( action.forbid_rebinding ) { // Hardwire the action since no binding is defined
				if ( action.gamepad != IC_none and __ICI.InterpretAction(player_number,action,ICDeviceType_gamepad,none) ) return true;
				if ( __INPUTCANDY.allow_keyboard_mouse and player_number == 1
				 and action.keyboard != IC_none and __ICI.InterpretAction(player_number,action,ICDeviceType_keyboard,none) ) return true;
				if ( __INPUTCANDY.allow_keyboard_mouse and player_number == 1
				 and action.mouse != IC_none and __ICI.InterpretAction(player_number,action,ICDeviceType_mouse,none) ) return true;
			} else {
				if ( action.gamepad != IC_none and __ICI.InterpretAction(player_number,action,ICDeviceType_gamepad,binding) ) return true;
				if ( __INPUTCANDY.allow_keyboard_mouse and player_number == 1
				 and action.keyboard != IC_none and __ICI.InterpretAction(player_number,action,ICDeviceType_keyboard,binding) ) return true;
				if ( __INPUTCANDY.allow_keyboard_mouse and player_number == 1
				 and action.mouse != IC_none and __ICI.InterpretAction(player_number,action,ICDeviceType_mouse,binding) ) return true;
			}
			return false;
		},
		KeyHeld: function ( ic_code ) {
			var len=array_length(__INPUTCANDY.keys);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.keys[i].button == ic_code
			  and __INPUTCANDY.keys[i].is_held ) return __INPUTCANDY.keys[i].held_for;
			return 0;
		},
		KeyDown: function ( ic_code ) {
			var len=array_length(__INPUTCANDY.keys);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.keys[i].button == ic_code
			  and __INPUTCANDY.keys[i].is_held ) return true;
			return false;
		},
		KeyUp: function ( ic_code ) {
			var len=array_length(__INPUTCANDY.keys);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.keys[i].button == ic_code
			  and __INPUTCANDY.keys[i].is_held ) return false;
			return true;
		},
		KeyReleased: function ( ic_code ) {
			var len=array_length(__INPUTCANDY.keys);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.keys[i].button == ic_code
			  and !__INPUTCANDY.keys[i].is_held
			  and __INPUTCANDY.keys[i].was_held ) return true;
			return false;
		},
		KeyPressed: function ( ic_code ) {
			var len=array_length(__INPUTCANDY.keys);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.keys[i].button == ic_code
			  and __INPUTCANDY.keys[i].is_held
			  and !__INPUTCANDY.key[i].was_held
			  and __INPUTCANDY.key[i].held_for == 1 ) return true;
			return false;
		},
		GetMouseState: function ( ic_code ) {
			switch ( ic_code ) {
				case IC_mouse_left: return __IC.MouseLeftHeld();
				case IC_mouse_right: return __IC.MouseRightHeld();
				case IC_mouse_middle: return __IC.MouseMiddleHeld();
				case IC_mouse_scrollup: return __IC.MouseScrolledUp();
				case IC_mouse_scrolldown: return __IC.MouseScrolledDown();
			}
			return false;
		},
		MouseLeftHeld: function () {
			var len=array_length(__INPUTCANDY.mouseStates);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.mouseStates[i].button == IC_mouse_left
			  and __INPUTCANDY.mouseStates[i].is_held ) return __INPUTCANDY.mouseStates[i].held_for;
			return 0;
		},
		MouseRightHeld: function () {
			var len=array_length(__INPUTCANDY.mouseStates);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.mouseStates[i].button == IC_mouse_right
			  and __INPUTCANDY.mouseStates[i].is_held ) return __INPUTCANDY.mouseStates[i].held_for;
			return 0;
		},
		MouseMiddleHeld: function () {
			var len=array_length(__INPUTCANDY.mouseStates);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.mouseStates[i].button == IC_mouse_middle
			  and __INPUTCANDY.mouseStates[i].is_held ) return __INPUTCANDY.mouseStates[i].held_for;
			return 0;
		},
		MouseScrolledUp: function () { return mouse_wheel_up(); },
		MouseScrolledDown: function () { return mouse_wheel_down(); },
		MouseWheelUp: function () { return mouse_wheel_up(); },
		MouseWheelDown: function () { return mouse_wheel_down(); },
		// Directly checks a signal, bypassing the Actions system, -1 means "none", otherwise # of frames its been held for
		Signal: function ( player_number, button_id ) {
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none or device >= array_length(__INPUTCANDY.devices) ) return 0;
			var len=array_length(__INPUTCANDY.states[device].signals);
			for ( var i=0; i<len; i++ )
			 if ( __INPUTCANDY.states[device].signals[i].button == button_id
			  and __INPUTCANDY.states[device].signals[i].is_held )
			   return __INPUTCANDY.states[device].signals[i].held_for;
			return 0;
		},
		// Directly checks signals from any device, bypassing the Actions system
		SignalAny: function ( button_id ) {
			var len=array_length(__INPUTCANDY.devices);
			for ( var i=0; i<len; i++ ) {
				var sigs=array_length(__INPUTCANDY.states[i].signals);
				for ( var j=0; j<sigs; j++ )
				 if ( __INPUTCANDY.states[i].signals[j].button == button_id
				  and __INPUTCANDY.states[i].signals[j].is_held )
				   return __INPUTCANDY.states[i].signals[j].held_for;
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
			return false;
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
			return false;
		},
		GetHatSignal: function ( player_number, hat_number ) {
			var hat={ up: false, down: false, left: false, right: false, H: AXIS_NO_VALUE, V: AXIS_NO_VALUE, value: AXIS_NO_VALUE, not_available: false };
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none or device >= array_length(__INPUTCANDY.devices) ) {
				hat.not_available=true;
				return hat;
			}
			if ( hat_number >= __INPUTCANDY.devices[device].hat_count ) {
				hat.not_available=true;
				return hat;
			}
			if ( hat_number <= 4 ) {
				switch ( hat_number ) {
					case 0:
						hat.up=__IC.Signal(player_number,IC_hat0_U);
						hat.down=__IC.Signal(player_number,IC_hat0_D);
						hat.left=__IC.Signal(player_number,IC_hat0_L);
						hat.right=__IC.Signal(player_number,IC_hat0_R);
			            hat.H=hat.left ? -1 : (hat.right ? 1 : 0); 
			            hat.V=hat.up ? -1 : (hat.down ? 1 : 0); 
			            hat.angle=__IC.AxisToAngle( hat.H, hat.V );
						hat.value=gamepad_hat_value( __INPUTCANDY.devices[device].slot_id, hat_number );
					break;
					case 1:
						hat.up=__IC.Signal(player_number,IC_hat1_U);
						hat.down=__IC.Signal(player_number,IC_hat1_D);
						hat.left=__IC.Signal(player_number,IC_hat1_L);
						hat.right=__IC.Signal(player_number,IC_hat1_R);
			            hat.H=hat.left ? -1 : (hat.right ? 1 : 0); 
			            hat.V=hat.up ? -1 : (hat.down ? 1 : 0); 
			            hat.angle=__IC.AxisToAngle( hat.H, hat.V );
						hat.value=gamepad_hat_value( __INPUTCANDY.devices[device].slot_id, hat_number );
					break;
					case 2:
						hat.up=__IC.Signal(player_number,IC_hat2_U);
						hat.down=__IC.Signal(player_number,IC_hat2_D);
						hat.left=__IC.Signal(player_number,IC_hat2_L);
						hat.right=__IC.Signal(player_number,IC_hat2_R);
			            hat.H=hat.left ? -1 : (hat.right ? 1 : 0); 
			            hat.V=hat.up ? -1 : (hat.down ? 1 : 0); 
			            hat.angle=__IC.AxisToAngle( hat.H, hat.V );
						hat.value=gamepad_hat_value( __INPUTCANDY.devices[device].slot_id, hat_number );
					break;
					case 3:
						hat.up=__IC.Signal(player_number,IC_hat3_U);
						hat.down=__IC.Signal(player_number,IC_hat3_D);
						hat.left=__IC.Signal(player_number,IC_hat3_L);
						hat.right=__IC.Signal(player_number,IC_hat3_R);
			            hat.H=hat.left ? -1 : (hat.right ? 1 : 0); 
			            hat.V=hat.up ? -1 : (hat.down ? 1 : 0); 
			            hat.angle=__IC.AxisToAngle( hat.H, hat.V );
						hat.value=gamepad_hat_value( __INPUTCANDY.devices[device].slot_id, hat_number );
					break;
					case 4:
						hat.up=__IC.Signal(player_number,IC_hat4_U);
						hat.down=__IC.Signal(player_number,IC_hat4_D);
						hat.left=__IC.Signal(player_number,IC_hat4_L);
						hat.right=__IC.Signal(player_number,IC_hat4_R);
			            hat.H=hat.left ? -1 : (hat.right ? 1 : 0); 
			            hat.V=hat.up ? -1 : (hat.down ? 1 : 0); 
			            hat.angle=__IC.AxisToAngle( hat.H, hat.V );
						hat.value=gamepad_hat_value( __INPUTCANDY.devices[device].slot_id, hat_number );
					break;
				}
				return hat;
			}
			var hat_value = gamepad_hat_value( __INPUTCANDY.devices[device].slot_id, hat_number );
			hat.up=hat_value & ICGamepad_Hat_U;
			hat.down=hat_value & ICGamepad_Hat_D;
			hat.left=hat_value & ICGamepad_Hat_L;
			hat.right=hat_value & ICGamepad_Hat_R;
			hat.H=hat.left ? -1 : (hat.right ? 1 : 0); 
			hat.V=hat.up ? -1 : (hat.down ? 1 : 0); 
			hat.angle=__IC.AxisToAngle( hat.H, hat.V );
			hat.value=hat_value;
			return hat;
		},
		GetAxisSignal: function ( player_number, axis_number ) {
			var axis={ up: false, down: false, left: false, right: false, value: AXIS_NO_VALUE, angle: AXIS_NO_VALUE, H: AXIS_NO_VALUE, V: AXIS_NO_VALUE, rH: AXIS_NO_VALUE, rV: AXIS_NO_VALUE, not_available: false };
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none or device >= array_length(__INPUTCANDY.devices) ) {
				axis.not_available=true;
				return axis;
			}
			if ( axis_number >= __INPUTCANDY.devices[device].axis_count ) {
				axis.not_available=true;
				return axis;
			}
			axis.values=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, axis_number);
			axis.H=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, gp_axislh);
			axis.V=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, gp_axislv);
			axis.rH=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, gp_axisrh);
			axis.rV=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, gp_axisrv);
			axis.deadzone = gamepad_get_axis_deadzone(__INPUTCANDY.devices[device].slot_id);
			axis.angle=__IC.AxisToAngle( axis.H, axis.V );
			var hat_value=__IC.AxisToHat( axis.H, axis.V );
			axis.up=hat_value & ICGamepad_Hat_U;
			axis.down=hat_value & ICGamepad_Hat_D;
			axis.left=hat_value & ICGamepad_Hat_L;
			axis.right=hat_value & ICGamepad_Hat_R;
			return axis;
		},
		GetStickSignal: function ( player_number, axis_number_X, axis_number_Y ) {
			var axis={ up: false, down: false, left: false, right: false, value: AXIS_NO_VALUE, angle: AXIS_NO_VALUE, H: AXIS_NO_VALUE, V: AXIS_NO_VALUE, rH: AXIS_NO_VALUE, rV: AXIS_NO_VALUE, not_available: false };
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none or device >= array_length(__INPUTCANDY.devices) ) {
				axis.not_available=true;
				return axis;
			}
			if ( axis_number_X >= __INPUTCANDY.devices[device].axis_count or axis_number_Y >= __INPUTCANDY.devices[device].axis_count ) {
				axis.not_available=true;
				return axis;
			}
			axis.indices=[ axis_number_X, axis_number_Y ];
			axis.H=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, axis_number_X);
			axis.V=gamepad_axis_value(__INPUTCANDY.devices[device].slot_id, axis_number_Y);
			axis.deadzone = gamepad_get_axis_deadzone(__INPUTCANDY.devices[device].slot_id);
			axis.angle=__IC.AxisToAngle( axis.H, axis.V );
			var hat_value=__IC.AxisToHat( axis.H, axis.V );
			axis.up=hat_value & ICGamepad_Hat_U;
			axis.down=hat_value & ICGamepad_Hat_D;
			axis.left=hat_value & ICGamepad_Hat_L;
			axis.right=hat_value & ICGamepad_Hat_R;
			return axis;
		},
		AxisToAngle: function ( H, V ) { return point_direction(0, 0, H, V); },
		AxisToHat: function ( H, V ) {
			var angle=__IC.AxisToAngle( H, V );
			var result=0;
			if ( angle >= 360-45 and angle <= 45 ) result |= ICGamepad_Hat_R;
			if ( angle >= 45 and angle <= 45+90 ) result |= ICGamepad_Hat_U;
			if ( angle >= 45+90 and angle <= 45+180 ) result |= ICGamepad_Hat_L;
			if ( angle >= 45+180 and angle <= 45+270 ) result |= ICGamepad_Hat_D;
			return result;
		},
		// Allocates a series of player profiles.  This is where you set your game's max players.  14 is a device maximum on Linux, 12 of Windows, 4 on Mac
		SetMaxPlayers: function ( max_players ) {
			var player_list=[];
			var len=array_length(__INPUTCANDY.players);
			for ( var i=0; i<max_players; i++ ) {
			  if ( i < len ) player_list[i]=__INPUTCANDY.players[i];
			  else player_list[i]=__ICI.New_ICPlayer();
			  player_list[i].index=i;
			}
			__INPUTCANDY.max_players=max_players;
			__INPUTCANDY.players=player_list;
		},
		// Returns the number of active players
		GetPlayers: function () { return __ICI.GetActivePlayers(); },
		GetPlayerIndex: function ( player_number ) { return player_number-1; },
		// Returns 1 if the player has been activated, 2 if the player doesn't exist or 3 was already active
		ActivatePlayer: function ( player_number ) {
			var player_index=player_number-1;
			if ( player_index >= array_length(__INPUTCANDY.max_players) ) return 2;
			if ( __INPUTCANDY.players[player_index].active ) return 3;
			__INPUTCANDY.players[player_index].active=true;
			return 1;
		},
		// Returns 1 if the player has been deactivated, 2 if the player doesn't exist or 3 was already not active
		DeactivatePlayer: function ( player_number ) {
			var player_index=player_number-1;
			if ( player_index >= array_length(__INPUTCANDY.max_players) ) return 2;
			if ( !__INPUTCANDY.players[player_index].active ) return 3;
			__INPUTCANDY.players[player_index].active=false;
			return 1;
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
		},
		KeyboardMouseDiagnosticString: function () {
			var out="";
			if ( !__INPUTCANDY.allow_keyboard_mouse ) out += "Mouse and keyboard disabled\n";
			if ( !__INPUTCANDY.player_using_keyboard_mouse ) out+="Player "+int(__INPUTCANDY.player_using_keyboard_mouse)+" uses Mouse and keyboard\n";
			else out+="Player 1 uses Mouse and Keyboard AND/OR Gamepad\n";
			out+="Mouse:     "+json_stringify(__INPUTCANDY.mouse)+"\n";
			out+="wasMouse: "+json_stringify(__INPUTCANDY.wasMouse)+"\n";
			out+="Mouse Button States:\n"+string_replace_all(json_stringify(__INPUTCANDY.mouseStates),"},","},\n")+"\n";
			out+="Keyboard States:\n"+string_replace_all(json_stringify(__INPUTCANDY.keys),"},","},\n")+"\n";
			return out;
		},
		PlayerDiagnosticString: function( player_number ) {
			var device=__INPUTCANDY.players[player_number-1].device;
			if ( device == none ) return "No device";
			return string_replace_all( json_stringify(__INPUTCANDY.states[device].signals), "},", "},\n" )+"\n";
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
		if ( __INPUTCANDY.steps < 5 ) {
			__INPUTCANDY.steps++;
			if ( __INPUTCANDY.steps == 5 ) {
				show_debug_message("InputCandy reached step 5.");
				__ICI.LoadSetup();
				__ICI.ActivateSetup();
				__ICI.ApplyDeviceSettings();
				//__ICI.ApplySDLMappings();
				show_debug_message("InputCandy leaving step 5.");
			}
		}
	 },
	 Init: function() {
		__INPUTCANDY.platform = __ICI.GetPlatformSpecifics();
		__ICI.LoadSettings();
		__ICI.LoadSetup();
		__IC.SetMaxPlayers(__INPUTCANDY.max_players);
		__INPUTCANDY.steps=0;
	 },
	 UpdateNetwork: function() { /* TODO */ },
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
			index: none,
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
			SDL_Mapping: "None"
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
		 var newly_devices_list=[];
		 // Poll all gamepad slots for connected devices.
		 var gamepads=gamepad_get_device_count();
		 for ( var i=0; i<gamepads; i++ ) {
			 if ( gamepad_is_connected(i) ) {
				var found=false;
				// See if the gamepad is already known about...
				for ( var k=0; k<existing; k++ ) {
					if ( __INPUTCANDY.devices[k].slot_id==i ) { found=true; break; }
				}
				if ( found ) continue;
				newly_devices_list[j]=__ICI.New_ICDevice();
				newly_devices_list[j].type = ICDeviceType_gamepad;
				// Associated and collect all information into the new devices list.
				newly_devices_list[j].slot_id=i;
				newly_devices_list[j].guid = gamepad_get_guid(i);
				newly_devices_list[j].desc = gamepad_get_description(i);
				newly_devices_list[j].hat_count = gamepad_hat_count(i);
				var btns= gamepad_button_count(i);
				newly_devices_list[j].button_count = btns;
				for ( var k=0; k<btns; k++ ) newly_devices_list[j].button_thresholds[k]=gamepad_get_button_threshold(i);
				var axes= gamepad_axis_count(i);
				newly_devices_list[j].axis_count = axes;
				for ( var k=0; k<axes; k++ ) newly_devices_list[j].axis_deadzones[k]=gamepad_get_axis_deadzone(i);
				newly_devices_list[j].index=j;
				newly_devices_list[j].sdl = SDLDB_Lookup_Device(newly_devices_list[j]);
				j++;
			 }
		 }
		 // Append detected devices not found in the already known and connected list
		 var len=array_length(newly_devices_list);
		 for ( var i=0; i<len; i++ ) {
			 var index=array_length(__INPUTCANDY.devices);
			 __INPUTCANDY.devices[index]=newly_devices_list[i];
			__INPUTCANDY.e_controller_connected(i,newly_devices_list[i]);
		 }
		 // Determine if any of the already known are still connected.  If not, prune in a special case, otherwise, create a new device profile and populate it.
		 j=0;
		 var devices_list=[];
		 len = array_length(__INPUTCANDY.devices);
		 for ( var i=0; i<len; i++ ) {
			 if ( __INPUTCANDY.devices[i].slot_id != none ) {
				 var connected=gamepad_is_connected(__INPUTCANDY.devices[i].slot_id);
				 if ( !connected ) {
					 // If this device profile is connected to a valid slot_id we need to copy it to the new list.
					__INPUTCANDY.e_controller_disconnected(i,__INPUTCANDY.devices[i]);
				 } else {
					 devices_list[j]=__INPUTCANDY.devices[i];
					 j++;
				 }
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
		if ( __INPUTCANDY.allow_keyboard_mouse && __INPUTCANDY.platform.keyboard_mouse_supported ) {
			__ICI.GetKeyboardMouseStates();
		}
	},
	ButtonStateIn: function ( code, keys, len ) {
		for ( var i=0; i<len; i++ ) if ( keys[i].button == code ) return keys[i];
		return none;
	},
	GetKeyboardMouseStates: function() {
		var previous_keys=__INPUTCANDY.keys;
		var previous_keys_length=array_length(__INPUTCANDY.keys);
		__INPUTCANDY.keys=[];
		var j=0;
		for ( var k=__FIRST_KEYBOARD_SIGNAL; k<__LAST_KEYBOARD_SIGNAL_PLUS_1; k++ ) {
			var signal=__INPUTCANDY.signals[k];
			var prev=ButtonStateIn(signal.code,previous_keys,previous_keys_length);
			var detected=false;
			switch ( signal.keyboardMethod ) {
				case ICKeyboardMethod_keycheck: detected = keyboard_check(signal.keycode); break;
				case ICKeyboardMethod_keycheck_direct: detected = keyboard_check_direct(signal.keycode); break;
				case ICKeyboardMethod_lastkey: if ( keyboard_key != 0 and keyboard_key == signal.keychar ) detected=true; break;
				case ICKeyboardMethod_ord: detected = keyboard_check(ord(signal.keychar)); break;
				default: show_debug_message("Invalid entry in INPUTCANDY's signals table! Index: "+int(k)); break;
			}
			if ( detected ) {
				var state=__ICI.New_ICButtonState();
				state.button=__INPUTCANDY.signals[k].code;
				state.signal_index=k;
				state.is_held = true;
				if ( prev != none ) {
					state.held_for = prev.held_for+1;
					state.was_held = true;
				} else state.held_for = 1;
				__INPUTCANDY.keys[j]=state;
				j++;
			} else if ( prev != none and prev.is_held == true ) {
				var state=__ICI.New_ICButtonState();
				state.button=__INPUTCANDY.signals[k].code;
				state.signal_index=k;
				state.is_held = false;
				state.was_held = true;
				state.held_for = prev.held_for+1;
				__INPUTCANDY.keys[j]=state;
				j++;
			}
		}
		//MOUSE
		var previous_mouse=__INPUTCANDY.mouseStates;
		var previous_mouse_len=array_length(__INPUTCANDY.mouseStates);
		__INPUTCANDY.wasMouse=__INPUTCANDY.mouse;
		__INPUTCANDY.mouse={ left: false, middle: false, right: false, up: false, down: false };
		__INPUTCANDY.mouseStates=[];
		j=0;
		k=__FIRST_MOUSE_SIGNAL;
		prev=ButtonStateIn(IC_mouse_left,previous_mouse,previous_mouse_len);
		if ( mouse_check_button(mb_left) ) {
			__INPUTCANDY.mouse.left=true;
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = true;
			if ( prev != none ) {
				state.held_for = prev.held_for+1;
				state.was_held = true;
			} else state.held_for = 1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		} else if ( prev != none and prev.is_held == true ) {
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = false;
			state.was_held = true;
			state.held_for = prev.held_for+1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		}
		k++;
		prev=ButtonStateIn(IC_mouse_right,previous_mouse,previous_mouse_len);
		if ( mouse_check_button(mb_right) ) {
			__INPUTCANDY.mouse.right=true;
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = true;
			if ( prev != none ) {
				state.held_for = prev.held_for+1;
				state.was_held = true;
			} else state.held_for = 1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		} else if ( prev != none and prev.is_held == true ) {
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = false;
			state.was_held = true;
			state.held_for = prev.held_for+1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		}
		k++;
		prev=ButtonStateIn(IC_mouse_middle,previous_mouse,previous_mouse_len);
		if ( mouse_check_button(mb_middle) ) {
			__INPUTCANDY.mouse.middle=true;
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = true;
			if ( prev != none ) {
				state.held_for = prev.held_for+1;
				state.was_held = true;
			} else state.held_for = 1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		} else if ( prev != none and prev.is_held == true ) {
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = false;
			state.was_held = true;
			state.held_for = prev.held_for+1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		}
		k++;
		prev=ButtonStateIn(IC_mouse_scrollup,previous_mouse,previous_mouse_len);
		if ( mouse_wheel_up() ) {
			__INPUTCANDY.mouse.up=true;
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = true;
			if ( prev != none ) {
				state.held_for = prev.held_for+1;
				state.was_held = true;
			} else state.held_for = 1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		} else if ( prev != none and prev.is_held == true ) {
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = false;
			state.was_held = true;
			state.held_for = prev.held_for+1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		}
		k++;
		prev=ButtonStateIn(IC_mouse_scrolldown,previous_mouse,previous_mouse_len);
		if ( mouse_wheel_down() ) {
			__INPUTCANDY.mouse.down=true;
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = true;
			if ( prev != none ) {
				state.held_for = prev.held_for+1;
				state.was_held = true;
			} else state.held_for = 1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		} else if ( prev != none and prev.is_held == true ) {
			var state=__ICI.New_ICButtonState();
			state.button=__INPUTCANDY.signals[k].code;
			state.signal_index=k;
			state.is_held = false;
			state.was_held = true;
			state.held_for = prev.held_for+1;
			__INPUTCANDY.mouseStates[j]=state;
			j++;
		}
		__INPUTCANDY.mouse.x=mouse_x;
		__INPUTCANDY.mouse.y=mouse_y;
	},
	New_ICAction: function () {
		return {
			index: none,
			name: "New Action",
			group: "None",
			gamepad: IC_none,
			gamepad_combo: false,
			keyboard: IC_none,
			keyboard_combo: false,
			mouse: IC_none,
			mouse_combo: false,
			mouse_keyboard_combo: false,
			is_directional: false,
			requires_angle: false,
			held_for_seconds: 0.0,
			fire_limit: 0,
			released: false,
			enabled: true,
			forbid_rebinding: false,
		};
	},
	CopyOfAction: function( action ) {
		return {
			index: action.index,
			name: action.name,
			group: action.group,
			gamepad: action.gamepad,
			gamepad_combo: action.gamepad_combo,
			keyboard: action.keyboard,
			keyboard_combo: action.keyboard_combo,
			mouse: action.mouse,
			mouse_combo: action.mouse_combo,
			mouse_keyboard_combo: action.keyboard_combo,
			is_directional: action.is_directional,
			requires_angle: action.requires_angle,
			held_for_seconds: action.held_for_seconds,
			fire_limit: action.fire_limit,
			released: action.released,
			enabled: action.enabled,
			forbid_rebinding: action.forbid_rebinding
		};
	},
	MatchSignal: function ( player_number, action, ic_code ) {
		if ( action.released ) {
			return __IC.SignalReleased(player_number,ic_code);
		} else {
			var s= (ic_code >= __FIRST_KEYBOARD_SIGNAL and ic_code < __LAST_KEYBOARD_SIGNAL_PLUS_1) ? __IC.KeyHeld(ic_code)
			 : ((ic_code >= __FIRST_MOUSE_SIGNAL and ic_code < __LAST_MOUSE_SIGNAL_PLUS_1) ? __IC.GetMouseState(ic_code)
			 : __IC.Signal(player_number,ic_code));
            if ( s == false ) return false;
			if ( s == none ) return false;
			if ( s == 0 ) return false;
			if ( action.fire_limit == 0 ) return s;
			var frames=1+floor(action.held_for_seconds * room_speed);
			if ( action.fire_limit == 1 and s == frames ) return true;
			else if ( frames > 0 and s % frames == 0 ) {
				var fired_times=floor(s/frames);
				if ( fired_times <= fire_limit ) return true;
				else return false;
			}
		}
	},
	MatchButtonList: function ( player_number, action, is_combo, buttonlist ) {
	 var len=array_length(buttonlist);
	 if ( is_combo ) {
	 	 var allMatch=true;
	 	 for ( var i=0; i<len; i++ )
			 if ( __ICI.MatchSignal( player_number, action, buttonlist[i]) == false ) { allMatch=false; break; }
		 return allMatch;
	 } else {
	 	 for ( var i=0; i<len; i++ )
			 if ( __ICI.MatchSignal( player_number, action, buttonlist[i]) != false ) return true;
		 return false;
	 }
	},
	MatchAction: function ( player_number, action, type ) {
		switch ( type ) { // type not binding
			case ICDeviceType_gamepad:
			 if ( is_array(action.gamepad) ) {
				 return __ICI.MatchButtonList( player_number, action, action.gamepad_combo, action.gamepad );
			 } else {
				 if ( action.gamepad != IC_none ) return __ICI.MatchSignal( player_number, action, action.gamepad );
				 return false;
			 }
			break;
			case ICDeviceType_keyboard:
			 if ( is_array(action.keyboard) ) {
				 return __ICI.MatchButtonList( player_number, action, action.keyboard_combo, action.keyboard );
			 } else {
				 if ( action.keyboard != IC_none ) return __ICI.MatchSignal( player_number, action, action.keyboard );
			 }
			break;
			case ICDeviceType_mouse:
			 if ( is_array(action.mouse) ) {
				 if ( action.mouse_keyboard_combo ) {
					 var matched_mouse=__ICI.MatchButtonList( player_number, action, action.mouse_keyboard_combo, action.mouse );
					 var matched_keyboard=__ICI.MatchButtonList( player_number, action, action.mouse_keyboard_combo, action.keyboard );
					 return matched_mouse && matched_keyboard;
				 } else return __ICI.MatchButtonList( player_number, action, action.mouse_combo, action.mouse );
			 } else {
				 if ( action.mouse != IC_none and __ICI.MatchSignal( player_number, action, action.mouse ) ) {
					 if ( !action.mouse_keyboard_combo ) {
						 return true;
					 } else {
						 if ( is_array(action.keyboard) ) {
							 return __ICI.MatchButtonList( player_number, action, action.keyboard_combo, action.keyboard );
						 } else {
							 if ( action.keyboard != IC_none ) return __ICI.MatchSignal( player_number, action, action.keyboard );
						 }
					 }
				 }
			 }
			break;
		}
		return false;
	},
	InterpretAction: function (player_number,action,type,binding) {
		var player_index=player_number-1;
		if ( action.enabled == false ) return false;
		if ( !action.forbid_rebinding and __INPUTCANDY.players[player_index].settings != none ) {
			if ( binding == unknown ) binding=__ICI.GetBinding( __INPUTCANDY.players[player_index].settings, action.index );
			if ( binding != none ) return __ICI.MatchAction( player_index, binding.bound_action, type );
		}
		return __ICI.MatchAction(player_number,action,type);
	},
	// Establish a "Moving" state object
	New_ICMoving: function () {
		return { up: false, down: false, left: false, right: false, value: AXIS_NO_VALUE, angle: AXIS_NO_VALUE, H: AXIS_NO_VALUE, V: AXIS_NO_VALUE, H2:[], V2:[], not_available: false };
	},
	_MovingOr: function ( moving, or_moving ) {
		if ( or_moving.up    ) moving.up=true;
		if ( or_moving.down  ) moving.down=true;
		if ( or_moving.left  ) moving.left=true;
		if ( or_moving.right ) moving.right=true;
		moving.H2[array_length(moving.H2)] = or_moving.H;
		moving.V2[array_length(moving.V2)] = or_moving.V;
        moving.angle = __IC.AxisToAngle( moving.H, moving.V );
		return moving;
	},
	_MovingAnd: function ( moving, and_moving ) {
		moving.up=    moving.up and and_moving.up;
		moving.down=  moving.down and and_moving.down;
		moving.left=  moving.left and and_moving.left;
		moving.right= moving.right and and_moving.right;
		moving.H2[array_length(moving.H2)] = and_moving.H;
		moving.V2[array_length(moving.V2)] = and_moving.V;
        moving.angle = __IC.AxisToAngle( moving.H, moving.V );
		return moving;
	},
    // When using bindings, special options can modify a "moving" state
	ApplyBindingToMoving: function ( binding, calibration_index, moving ) {
		if ( calibration_index == none or calibration_index >= array_length(binding.calibration) ) return moving;
		var calibration=binding.calibration[calibration_index];
		if ( calibration.rotate ) { // Swap Left-Right for Up-Down
			var V=moving.V;
			moving.V=moving.H;
			moving.H=V;
			var up=moving.up;
			moving.up=moving.right;
			moving.right=up;
			var down=moving.down;
			moving.down=moving.left;
			moving.left=down;
		}
		if ( calibration.reverse ) { // Swap Left for Right
			var left=moving.left;
			moving.left=moving.right;
			moving.right=left;
			if ( moving.H != AXIS_NO_VALUE ) moving.H=-moving.H;
		}
		if ( calibration.invert ) { // Swap Up for Down
			var up=moving.up;
			moving.up=moving.down;
			moving.down=up;
			if ( moving.V != AXIS_NO_VALUE ) moving.V=-moving.V;
		}
		return moving;
	},
	GetDirectional: function ( player_index, moving, type ) {
		var player_number=player_index+1;
		if ( __INPUTCANDY.players[player_index].device == none ) return moving;
		switch ( type ) {
			default: break;
			case IC_dpad:
			 moving.up=__IC.Signal(player_number,IC_padu);
			 moving.down=__IC.Signal(player_number,IC_padd);
			 moving.left=__IC.Signal(player_number,IC_padl);
			 moving.right=__IC.Signal(player_number,IC_padr);
			 moving.H=moving.left ? -1 : (moving.right ? 1 : 0);
			 moving.V=moving.up ? -1 : (moving.down ? 1 : 0);
			 moving.angle = __IC.AxisToAngle( moving.H, moving.V );
			break;
			case IC_hat0: { var sig=__IC.GetHatSignal( player_number, 0 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat1: { var sig=__IC.GetHatSignal( player_number, 1 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat2: { var sig=__IC.GetHatSignal( player_number, 2 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat3: { var sig=__IC.GetHatSignal( player_number, 3 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat4: { var sig=__IC.GetHatSignal( player_number, 4 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat5: { var sig=__IC.GetHatSignal( player_number, 5 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat6: { var sig=__IC.GetHatSignal( player_number, 6 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat7: { var sig=__IC.GetHatSignal( player_number, 7 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat8: { var sig=__IC.GetHatSignal( player_number, 8 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_hat9: { var sig=__IC.GetHatSignal( player_number, 9 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis0: { var sig=__IC.GetAxisSignal( player_number, 0 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis1: { var sig=__IC.GetAxisSignal( player_number, 1 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis2: { var sig=__IC.GetAxisSignal( player_number, 2 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis3: { var sig=__IC.GetAxisSignal( player_number, 3 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis4: { var sig=__IC.GetAxisSignal( player_number, 4 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis5: { var sig=__IC.GetAxisSignal( player_number, 5 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis6: { var sig=__IC.GetAxisSignal( player_number, 6 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis7: { var sig=__IC.GetAxisSignal( player_number, 7 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis8: { var sig=__IC.GetAxisSignal( player_number, 8 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_axis9: { var sig=__IC.GetAxisSignal( player_number, 9 ); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=__IC.AxisToAngle( moving.H, moving.V ); } } break;
			case IC_stick_01: { var sig=__IC.GetStickSignal(player_number,0,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_02: { var sig=__IC.GetStickSignal(player_number,0,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_03: { var sig=__IC.GetStickSignal(player_number,0,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_04: { var sig=__IC.GetStickSignal(player_number,0,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_05: { var sig=__IC.GetStickSignal(player_number,0,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_06: { var sig=__IC.GetStickSignal(player_number,0,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_07: { var sig=__IC.GetStickSignal(player_number,0,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_08: { var sig=__IC.GetStickSignal(player_number,0,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_09: { var sig=__IC.GetStickSignal(player_number,0,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_10: { var sig=__IC.GetStickSignal(player_number,1,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_12: { var sig=__IC.GetStickSignal(player_number,1,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_13: { var sig=__IC.GetStickSignal(player_number,1,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_14: { var sig=__IC.GetStickSignal(player_number,1,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_15: { var sig=__IC.GetStickSignal(player_number,1,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_16: { var sig=__IC.GetStickSignal(player_number,1,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_17: { var sig=__IC.GetStickSignal(player_number,1,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_18: { var sig=__IC.GetStickSignal(player_number,1,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_19: { var sig=__IC.GetStickSignal(player_number,1,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_20: { var sig=__IC.GetStickSignal(player_number,2,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_21: { var sig=__IC.GetStickSignal(player_number,2,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_23: { var sig=__IC.GetStickSignal(player_number,2,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_24: { var sig=__IC.GetStickSignal(player_number,2,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_25: { var sig=__IC.GetStickSignal(player_number,2,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_26: { var sig=__IC.GetStickSignal(player_number,2,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_27: { var sig=__IC.GetStickSignal(player_number,2,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_28: { var sig=__IC.GetStickSignal(player_number,2,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_29: { var sig=__IC.GetStickSignal(player_number,2,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_30: { var sig=__IC.GetStickSignal(player_number,3,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_31: { var sig=__IC.GetStickSignal(player_number,3,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_32: { var sig=__IC.GetStickSignal(player_number,3,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_34: { var sig=__IC.GetStickSignal(player_number,3,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_35: { var sig=__IC.GetStickSignal(player_number,3,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_36: { var sig=__IC.GetStickSignal(player_number,3,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_37: { var sig=__IC.GetStickSignal(player_number,3,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_38: { var sig=__IC.GetStickSignal(player_number,3,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_39: { var sig=__IC.GetStickSignal(player_number,3,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_40: { var sig=__IC.GetStickSignal(player_number,4,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_41: { var sig=__IC.GetStickSignal(player_number,4,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_42: { var sig=__IC.GetStickSignal(player_number,4,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_43: { var sig=__IC.GetStickSignal(player_number,4,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_45: { var sig=__IC.GetStickSignal(player_number,4,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_46: { var sig=__IC.GetStickSignal(player_number,4,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_47: { var sig=__IC.GetStickSignal(player_number,4,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_48: { var sig=__IC.GetStickSignal(player_number,4,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_49: { var sig=__IC.GetStickSignal(player_number,4,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_50: { var sig=__IC.GetStickSignal(player_number,5,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_51: { var sig=__IC.GetStickSignal(player_number,5,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_52: { var sig=__IC.GetStickSignal(player_number,5,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_53: { var sig=__IC.GetStickSignal(player_number,5,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_54: { var sig=__IC.GetStickSignal(player_number,5,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_56: { var sig=__IC.GetStickSignal(player_number,5,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_57: { var sig=__IC.GetStickSignal(player_number,5,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_58: { var sig=__IC.GetStickSignal(player_number,5,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_59: { var sig=__IC.GetStickSignal(player_number,5,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_60: { var sig=__IC.GetStickSignal(player_number,6,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_61: { var sig=__IC.GetStickSignal(player_number,6,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_62: { var sig=__IC.GetStickSignal(player_number,6,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_63: { var sig=__IC.GetStickSignal(player_number,6,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_64: { var sig=__IC.GetStickSignal(player_number,6,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_65: { var sig=__IC.GetStickSignal(player_number,6,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_67: { var sig=__IC.GetStickSignal(player_number,6,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_68: { var sig=__IC.GetStickSignal(player_number,6,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_69: { var sig=__IC.GetStickSignal(player_number,6,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_70: { var sig=__IC.GetStickSignal(player_number,7,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_71: { var sig=__IC.GetStickSignal(player_number,7,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_72: { var sig=__IC.GetStickSignal(player_number,7,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_73: { var sig=__IC.GetStickSignal(player_number,7,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_74: { var sig=__IC.GetStickSignal(player_number,7,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_75: { var sig=__IC.GetStickSignal(player_number,7,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_76: { var sig=__IC.GetStickSignal(player_number,7,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_78: { var sig=__IC.GetStickSignal(player_number,7,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_79: { var sig=__IC.GetStickSignal(player_number,7,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_80: { var sig=__IC.GetStickSignal(player_number,8,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_81: { var sig=__IC.GetStickSignal(player_number,8,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_82: { var sig=__IC.GetStickSignal(player_number,8,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_83: { var sig=__IC.GetStickSignal(player_number,8,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_84: { var sig=__IC.GetStickSignal(player_number,8,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_85: { var sig=__IC.GetStickSignal(player_number,8,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_86: { var sig=__IC.GetStickSignal(player_number,8,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_87: { var sig=__IC.GetStickSignal(player_number,8,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_89: { var sig=__IC.GetStickSignal(player_number,8,9); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_90: { var sig=__IC.GetStickSignal(player_number,9,0); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_91: { var sig=__IC.GetStickSignal(player_number,9,1); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_92: { var sig=__IC.GetStickSignal(player_number,9,2); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_93: { var sig=__IC.GetStickSignal(player_number,9,3); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_94: { var sig=__IC.GetStickSignal(player_number,9,4); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_95: { var sig=__IC.GetStickSignal(player_number,9,5); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_96: { var sig=__IC.GetStickSignal(player_number,9,6); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_97: { var sig=__IC.GetStickSignal(player_number,9,7); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;
			case IC_stick_98: { var sig=__IC.GetStickSignal(player_number,9,8); if ( !sig.not_available ) { moving.H=sig.H; moving.V=sig.V; moving.up=sig.up; moving.down=sig.down; moving.left=sig.left; moving.right=sig.right; moving.angle=sig.angle; } } break;			
			case IC_arrows:
			 if ( __INPUTCANDY.allow_keyboard_mouse and player_index == __INPUTCANDY.player_using_keyboard_mouse ) {
				moving.up=__IC.KeyHeld( IC_key_arrow_U );
				moving.down=__IC.KeyHeld( IC_key_arrow_D );
				moving.left=__IC.KeyHeld( IC_key_arrow_L );
				moving.right=__IC.KeyHeld( IC_key_arrow_R );
				moving.H=moving.left ? -1 : (moving.right ? 1 : 0);
				moving.V=moving.up ? -1 : (moving.down ? 1 : 0);
				moving.angle = __IC.AxisToAngle( moving.H, moving.V );
			 }
			break;
			case IC_wasd:
			 if ( __INPUTCANDY.allow_keyboard_mouse and player_index == __INPUTCANDY.player_using_keyboard_mouse ) {
				moving.up=__IC.KeyHeld( IC_key_W );
				moving.down=__IC.KeyHeld( IC_key_S );
				moving.left=__IC.KeyHeld( IC_key_A );
				moving.right=__IC.KeyHeld( IC_key_D );
				moving.H=moving.left ? -1 : (moving.right ? 1 : 0);
				moving.V=moving.up ? -1 : (moving.down ? 1 : 0);
				moving.angle = __IC.AxisToAngle( moving.H, moving.V );
			 }
			break;
			case IC_numpad:
			 if ( __INPUTCANDY.allow_keyboard_mouse and player_index == __INPUTCANDY.player_using_keyboard_mouse ) {
				moving.up=__IC.KeyHeld( IC_numpad8 );
				moving.down=__IC.KeyHeld( IC_numpad2 );
				moving.left=__IC.KeyHeld( IC_numpad4 );
				moving.right=__IC.KeyHeld( IC_numpad6 );
				moving.H=moving.left ? -1 : (moving.right ? 1 : 0);
				moving.V=moving.up ? -1 : (moving.down ? 1 : 0);
				moving.angle = __IC.AxisToAngle( moving.H, moving.V );
			 }
			break;
		}
		return moving;
	},
	GetDirectionalByCode: function ( code ) {
		var len = array_length(__INPUTCANDY.directionals);
		for ( var j=0; j<len; j++ ) {
			if ( __INPUTCANDY.directionals[j].code == code ) return j;
		}
		return none;
	},
	GetStickByAxisPair: function ( haxis, vaxis ) {
		var len=__ICI.GetDirectionalByCode(IC_stick_98);
		for ( var j=__ICI.GetDirectionalByCode(IC_stick_01); j<len; j++ ) {
			if ( (__INPUTCANDY.directionals[j].stickH == haxis
			 and __INPUTCANDY.directionals[j].stickV == vaxis) ) return j;
		}
		return none;
	},
	DirectionalSupported: function ( device, directional_index ) {
		if ( device == none ) return false;
		var d=__INPUTCANDY.directionals[directional_index];
		if ( d.code == IC_dpad ) return true;
		if ( d.code >= IC_hat0 and d.code <= IC_hat9 ) {
			var hat_index=d.code - IC_hat0;
			if ( hat_index < device.hat_count ) return true;
		}
		/*
		if ( d.code >= IC_axis0 and d.code <= IC_axis9 ) {
			var ax_index=d.code - IC_axis0;
			if ( ax_index < device.axis_count ) return true;
		}
		*/
		if ( d.code >= IC_stick_01 and d.code <= IC_stick_98 ) {
			if ( device.axis_count >= 10 ) return true;
			if ( device.axis_count <= 1 ) return false;
			if ( d.stickH < device.axis_count and d.stickV < device.axis_count ) return true;
		}
		return false;
	},
	MatchBoundDirectional: function (player_index,action_index,action,binding,moving) {
		var first_found=false;
		if ( is_array(binding.bound_action.gamepad) ) {
			var len=array_length(binding.bound_action.gamepad);
			for ( var i=0; i<len; i++ ) {
				if ( binding.bound_action.gamepad == IC_dpad
				  or (binding.bound_action.gamepad >= IC_hat0 and binding.bound_action.gamepad <= IC_hat9)
				  or (binding.bound_action.gamepad >= IC_axis0 and binding.bound_action.gamepad <= IC_axis9) ) {
				  var value=__ICI.GetDirectional(player_index,moving,binding.bound_action.gamepad);
				  if ( !first_found ) { moving=value; first_found=true; }
				  else if ( binding.bound_action.gamepad_combo ) moving=__ICI._MovingAnd(moving,value);
				  else moving=__ICI._MovingOr(moving,value);
				}
			}
		} else {
			if ( binding.bound_action.gamepad == IC_dpad
			  or (binding.bound_action.gamepad >= IC_hat0 and binding.bound_action.gamepad <= IC_hat9)
			  or (binding.bound_action.gamepad >= IC_axis0 and binding.bound_action.gamepad <= IC_axis9) ) {
				  first_found=true;
				  moving=__ICI.GetDirectional(player_index,moving,binding.bound_action.gamepad);
			}
		}
		if ( player_index == 0 ) {
			if ( is_array(binding.bound_action.keyboard) ) {
				var len=array_length(binding.bound_action.keyboard);
				for ( var i=0; i<len; i++ ) {
					if ( binding.bound_action.keyboard == IC_arrows
					  or binding.bound_action.keyboard == IC_numpad
					  or binding.bound_action.keyboard == IC_wasd ) {
					  var value=__ICI.GetDirectional(player_index,moving,binding.bound_action.keyboard);
					  value=__ICI.ApplyBindingToMoving(binding,i,moving);
					  if ( !first_found ) { moving=value; first_found=true; }
					  else if ( binding.bound_action.keyboard_combo ) moving=__ICI._MovingAnd(moving,value);
					  else moving=__ICI._MovingOr(moving,value);
					}
				}
			} else if ( binding.bound_action.keyboard != IC_none ) {				
				if ( binding.bound_action.keyboard == IC_arrows
				  or binding.bound_action.keyboard == IC_numpad
				  or binding.bound_action.keyboard == IC_wasd ) {
					if ( first_found ) {
						moving=__ICI._MovingOr(moving,__ICI.GetDirectional(player_index,moving,binding.bound_action.keyboard));
					} else moving=__ICI.GetDirectional(player_index,moving,binding.bound_action.keyboard);
				}
			}
		}
		return moving;
	},
	// Call only on actions that are is_directional
	MatchDirectional: function (player_index,action_index,action) {
		var settings_index = __INPUTCANDY.players[player_index].settings;
		//var device_index = __INPUTCANDY.players[player_index].device;
		var moving=__ICI.New_ICMoving();
		if ( settings_index >= 0 ) {
		 var settings=__INPUTCANDY.settings[settings_index];
		 var binding=__ICI.GetBinding( settings_index, action_index );
		 if ( binding != none and binding.bound_action != none and binding.bound_action.is_directional ) return MatchBoundDirectional(player_index,action_index,action,binding,moving);
		}
		// No binding found.
		var first_found=false;
		if ( is_array(action.gamepad) ) {
			var len=array_length(action.gamepad);
			for ( var i=0; i<len; i++ ) {
				if ( action.gamepad == IC_dpad
				  or (action.gamepad >= IC_hat0 and action.gamepad <= IC_hat9)
				  or (action.gamepad >= IC_axis0 and action.gamepad <= IC_axis9) ) {
				  var value=__ICI.GetDirectional(player_index,moving,action.gamepad);
				  if ( !first_found ) { moving=value; first_found=true; }
				  else if ( action.gamepad_combo ) moving=__ICI._MovingAnd(moving,value);
				  else moving=__ICI._MovingOr(moving,value);
				}
			}
		} else {
			if ( action.gamepad == IC_dpad
			  or (action.gamepad >= IC_hat0 and action.gamepad <= IC_hat9)
			  or (action.gamepad >= IC_axis0 and action.gamepad <= IC_axis9) ) {
				  first_found=true;
				  moving=__ICI.GetDirectional(player_index,moving,action.gamepad);
			}
		}
		if ( player_index == 0 ) {
			if ( is_array(action.keyboard) ) {
				var len=array_length(action.keyboard);
				for ( var i=0; i<len; i++ ) {
					if ( action.keyboard == IC_arrows
					  or action.keyboard == IC_numpad
					  or action.keyboard == IC_wasd ) {
					  var value=__ICI.GetDirectional(player_index,moving,action.keyboard);
					  if ( !first_found ) { moving=value; first_found=true; }
					  else if ( action.keyboard_combo ) moving=__ICI._MovingAnd(moving,value);
					  else moving=__ICI._MovingOr(moving,value);
					}
				}
			} else if ( action.keyboard != IC_none ) {				
				if ( action.keyboard == IC_arrows
				  or action.keyboard == IC_numpad
				  or action.keyboard == IC_wasd ) {
					if ( first_found ) {
						moving=__ICI._MovingOr(moving,__ICI.GetDirectional(player_index,moving,action.keyboard));
					} else moving=__ICI.GetDirectional(player_index,moving,action.keyboard);
				}
			}
		}
		return moving;
	},	
	
	//// PLAYERS
	New_ICPlayer: function () {
		return {
			index: none,
			settings: none,   // Index for settings profile
			device: none,
			active: false,    // It's up to you to maintain this.  Set to true once a player is "in the game", and false once they are "out of the game"
			data: {}          // This is left here so you can add additional values yourself to a player, like if they are on a high score screen, or in character select mode, etc.
		};
	},	
	
	//// SETTING	
	New_ICSettings: function () {
		return {
			index: none,
			deviceInfo: none,
			deadzone1: IC_absolute_minimum_deadzone,
			deadzone2: IC_absolute_minimum_deadzone,
			bindings: []
		};
	},
	
	GetSettings: function( player_number ) {
		var player_index=player_number-1;
		if ( __INPUTCANDY.players[player_index].settings == none ) return none;
		var len=array_length(__INPUTCANDY.settings);
		if ( __INPUTCANDY.players[player_index].settings < len ) return __INPUTCANDY.settings[__INPUTCANDY.players[player_index].settings];
		return none;
	},

	GetSettingsIndex: function( player_number ) {
		var player_index=player_number-1;
		if ( __INPUTCANDY.players[player_index].settings == none ) return none;
		var len=array_length(__INPUTCANDY.settings);
		if ( __INPUTCANDY.players[player_index].settings < len ) return __INPUTCANDY.players[player_index].settings;
		return none;
	},
	
	SetSettings: function (player_number, settings_index) {
		var player_index=player_number-1;
		__INPUTCANDY.players[player_index].settings=settings_index;
	},
	
	AddSettings: function() {
		var index=array_length(__INPUTCANDY.settings);
		__INPUTCANDY.settings[index]=New_ICSettings();
		__INPUTCANDY.settings[index].index=index;
		if ( argument_count > 0 ) __ICI.SetSettings(argument0,index);
		return index;
	},
	
	RemoveSettings: function( settings_index ) {
		// Players: Remove any direct references
		// Players: Renumber other references
		// Delete settings from list, reindexing the list.
	},
	
	// Device info can be used to attempt to predict which device gets which bindings.
	AssociateSettingsWithDevice: function( settings_index, device_index ) {
		__INPUTCANDY.settings[settings_index].deviceInfo = __INPUTCANDY.devices[device_index];
	},
	
	//// BINDING
	New_ICBinding: function() {
		return {
			index: none,
			action: none,     // Saves as a string, loads and is turned into an int
			group: "",        // Used in the loading and saving process.
			bound_action: none,
			calibrations: []
		};
	},	
	
	AddBinding: function( setting_index, from_action_index ) {
		var index=array_length(__INPUTCANDY.settings[setting_index].bindings);
		__INPUTCANDY.settings[setting_index].bindings[index]= __ICI.New_ICBinding();
		__INPUTCANDY.settings[setting_index].bindings[index].index=index;
		__INPUTCANDY.settings[setting_index].bindings[index].action=from_action_index;
		__INPUTCANDY.settings[setting_index].bindings[index].group=__INPUTCANDY.actions[from_action_index].group;
		__INPUTCANDY.settings[setting_index].bindings[index].bound_action = __ICI.CopyOfAction( __INPUTCANDY.actions[from_action_index] );
		return index;
	},
	
	GetBinding: function ( settings_index, action_index ) {
	 var bindings=array_length(__INPUTCANDY.settings[settings_index].bindings);
     for ( var i=0; i<bindings; i++ ) if ( __INPUTCANDY.settings[settings_index].bindings[i].action == action_index ) return i;
	 return none;
	},
	
	GetBindingData: function ( settings_index, action_index ) {
	 var bindings=array_length(__INPUTCANDY.settings[settings_index].bindings);
     for ( var i=0; i<bindings; i++ ) if ( __INPUTCANDY.settings[settings_index].bindings[i].action == action_index ) return __INPUTCANDY.settings[settings_index].bindings[i];
	 return none;
	},
	
	// The following are used in ui.input_binding for testing if a code or code set is already in use.
	
	CodeMatches: function ( code, single_array ) {
		var c;
		if ( !is_array(code) ) c[0]=code;
		else c=code;
		var a;
		if ( !is_array(single_array) ) a[0]=single_array;
		else a=single_array;
		var len=array_length(a);
		var len2=array_length(c);
		for ( var i=0; i<len; i++ ) {
			for ( var j=0; j<len2; j++ ) if ( c[j] == a[i] ) return true;
		}
		return false;
	},
	
	CodeMatchesAll: function ( code, single_array ) {
		var c;
		if ( !is_array(code) ) c[0]=code;
		else c=code;
		var a;
		if ( !is_array(single_array) ) a[0]=single_array;
		else a=single_array;
		var len=array_length(a);
		var len2=array_length(c);
		if ( len != len2 ) return false;
		for ( var i=0; i<len; i++ ) {
			var found=false;
			for ( var j=0; j<len2; j++ ) if ( c[j] == a[i] ) { found=true; break; }
			if ( !found ) return false;
		}
		return true;
	},
			
	ActionMatches: function( action, code ) {
	 if ( action.is_directional ) {
		 return __ICI.CodeMatches(code,action.gamepad) || __ICI.CodeMatches(code,action.keyboard) || __ICI.CodeMatches(code,action.mouse);
	 } else {
		if ( action.mouse_combo ) {
			if ( __ICI.CodeMatchesAll(code,action.mouse) ) return true;
		} else {
			if ( __ICI.CodeMatches(code,action.mouse) ) return true;
		}
		if ( action.keyboard_combo ) {
			if ( __ICI.CodeMatchesAll(code,action.keyboard) ) return true;
		} else {
			if ( __ICI.CodeMatches(code,action.keyboard) ) return true;
		}
		if ( action.gamepad_combo ) {
			if ( __ICI.CodeMatchesAll(code,action.gamepad) ) return true;
		} else {
			if ( __ICI.CodeMatches(code,action.gamepad) ) return true;
		}
	 }
	 return false;
	},
	
	GetActionsBindingsByCode: function ( settings_index, code, exclude, for_action ) {
	 var result={actions:[], actions_count:0, bindings:[], bindings_count:0 };
	 var bindings=array_length(__INPUTCANDY.settings[settings_index].bindings);
     for ( var i=0; i<bindings; i++ ) {
		if ( i == exclude ) continue;
		var b= __INPUTCANDY.settings[settings_index].bindings[i];
		if ( __ICI.ActionMatches( b.bound_action, code ) ) result.bindings[array_length(result.bindings)]=b;
	 }
	 result.bindings_count=array_length(result.bindings);
	 var actions=array_length(__INPUTCANDY.actions);
     for ( var i=0; i<actions; i++ ) {
		if ( i==for_action ) continue;
		if ( __ICI.ActionMatches( __INPUTCANDY.actions[i], code ) ) result.actions[array_length(result.actions)]=__INPUTCANDY.actions[i];
	 }
	 var list=[];
	 result.actions_count=array_length(result.actions);
	 for ( var i=0; i<result.actions_count; i++ ) {
		var is_overridden=false;
		for ( var j=0; j<result.bindings_count; j++ ) {
			if ( result.actions[i].index == result.bindings[j].action ) { is_overridden=true; break; }
		}
		if ( !is_overridden ) list[array_length(list)]=result.actions[i];
	 }
	 result.actions=list;
	 result.actions_count=array_length(result.actions);
	 //show_debug_message("GetActionsBindingByCode:");
	 //show_debug_message(json_stringify(result));
	 return result;
	},
	
	RemoveBinding: function ( settings_index, action_index ) {
		var list=[];
		var len=array_length(__INPUTCANDY.settings[settings_index]);
		for ( var i=0; i<len; i++ ) {
			if ( __INPUTCANDY.settings[settings_index].bindings[i].action == action_index ) {
				continue;
			}
			list[array_length(list)]= __INPUTCANDY.settings[settings_index].bindings[i];
		}
 	    __INPUTCANDY.settings[settings_index].bindings=list;
	},
	
	// Call only to set Gamepad
	SetBindingGamepad: function( settings_index, action_index, binding_index, gamepad ) {
		if ( binding_index == none ) binding_index = __ICI.AddBinding( settings_index, action_index );
		__INPUTCANDY.settings[settings_index].bindings[binding_index].action=action_index;
		__INPUTCANDY.settings[settings_index].bindings[binding_index].bound_action.gamepad=gamepad;
	},

    // Call only to set Keyboard
	SetBindingKeyboard: function( settings_index, action_index, binding_index, keyboard ) {
		if ( binding_index == none ) binding_index = __ICI.AddBinding( settings_index, action_index );
		__INPUTCANDY.settings[settings_index].bindings[binding_index].action=action_index;
		__INPUTCANDY.settings[settings_index].bindings[binding_index].bound_action.keyboard=keyboard;
	},

    // Call only to set Mouse
	SetBindingMouse: function( settings_index, action_index, binding_index, mouse ) {
		if ( binding_index == none ) binding_index = __ICI.AddBinding( settings_index, action_index );
		__INPUTCANDY.settings[settings_index].bindings[binding_index].action=action_index;
		__INPUTCANDY.settings[settings_index].bindings[binding_index].bound_action.mouse=mouse;
	},

    // Call only when it is a Keyboard-Mouse combo
	SetBindingKeyboardMouse: function( settings_index, action_index, binding_index, keyboard, mouse ) {
		if ( binding_index == none ) binding_index = __ICI.AddBinding( settings_index, action_index );
		__INPUTCANDY.settings[settings_index].bindings[binding_index].action=action_index;
		__INPUTCANDY.settings[settings_index].bindings[binding_index].bound_action.mouse=mouse;
		__INPUTCANDY.settings[settings_index].bindings[binding_index].bound_action.keyboard=keyboard;
	},	
	
	///// File saving and loading for settings and setup.
	
	PostLoadBinding: function( binding ) {
		var new_json=json_parse(json_stringify(binding));
		var action_index =  __IC.GetAction( binding.action, binding.group );
		if ( action_index < 0 ) return false;
		new_json.action = action_index;
		new_json.bound_action.index = action_index;
		return new_json;
	},
	
	PreSaveBinding: function( binding ) {
		var action=__INPUTCANDY.actions[binding.action];
		var new_jsonifiable={
			action: action.name,
			group: action.group,
			calibrations: binding.calibrations,
			bound_action: json_parse(json_stringify(binding.bound_action))
		};
		return new_jsonifiable;
	},
	
	SaveSettings: function() {
		var output=[];
		var len=array_length(__INPUTCANDY.settings);
		for ( var i=0; i<len; i++ ){
			var s=__INPUTCANDY.settings[i];
			output[i]={				
			    index: s.index,
			    deviceInfo: s.deviceInfo,
			    deadzone1: (s.deadzone1<IC_absolute_minimum_deadzone?IC_absolute_minimum_deadzone:s.deadzone1),
			    deadzone2: (s.deadzone2<IC_absolute_minimum_deadzone?IC_absolute_minimum_deadzone:s.deadzone2),
				bindings:[]
			}
			var blen=array_length(s.bindings);
			var k=0;
			for ( var j=0; j<blen; j++ ) {
			   if ( s.bindings[j].action == none ) continue;
			   output[i].bindings[k]=__ICI.PreSaveBinding(s.bindings[j]);
			   k++;
			}
		}
		__INPUTCANDY.e_save_file(__INPUTCANDY.settings_filename,output);
		show_debug_message("SaveSettings:");
		show_debug_message(json_stringify(__INPUTCANDY.settings));
		__ICI.SaveSetup();
	},
	
	LoadSettings: function() {
		var a=__INPUTCANDY.e_load_file(__INPUTCANDY.settings_filename,[]);
		if ( !is_array(a) ) return;
		var len=array_length(a);
		__INPUTCANDY.settings=[];
		for ( var i=0; i<len; i++ ) {
			var s={ index: i };
			s.deviceInfo=a[i].deviceInfo;
			s.bindings=[];
			s.deadzone1 =a[i].deadzone1; if ( s.deadzone1 < IC_absolute_minimum_deadzone ) s.deadzone1 = IC_absolute_minimum_deadzone;
			s.deadzone2 =a[i].deadzone2; if ( s.deadzone2 < IC_absolute_minimum_deadzone ) s.deadzone2 = IC_absolute_minimum_deadzone;
			var blen=array_length(a[i].bindings);
			var k=0;
			for ( var j=0; j<blen; j++ ) {
				var res=__ICI.PostLoadBinding(a[i].bindings[j]);
				if ( !res ) {
					show_debug_message("__ICI.LoadSettings: Could not locate an action for "+json_stringify(a[i].bindings[j]));
					continue;
				}
				if ( res.action == none ) continue;
				s.bindings[k]=res;
				k++;
			}
			__INPUTCANDY.settings[i]=s;
		}
		show_debug_message("LoadSettings:");
		show_debug_message(json_stringify(__INPUTCANDY.settings));
	},
	
	//// Associates device configurations with their players and settings, 
	//// so upon reloading of the game the same settings, devices and players are associated.
	
	New_ICSetup: function() {
		return {
			devices: [],
			settings: [],
			deviceInfo: []
		};
	},
	
	// Since setup is driven by the current state, we create an IC setup from the existing configuration.
	CurrentSetup: function() {
		var setup=__ICI.New_ICSetup();		
		for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
			setup.devices[array_length(setup.devices)]=__INPUTCANDY.players[i].device;
			setup.settings[array_length(setup.settings)]=__INPUTCANDY.players[i].settings;
			if ( __INPUTCANDY.players[i].device == none ) setup.deviceInfo[array_length(setup.deviceInfo)]=none;
			else setup.deviceInfo[array_length(setup.deviceInfo)]=__INPUTCANDY.devices[__INPUTCANDY.players[i].device];
		}
		return setup;
	},

	// Saves prior setup to disk.
	SaveSetup: function() {
		__INPUTCANDY.e_save_file(__INPUTCANDY.setup_filename,__INPUTCANDY.setup);
	},
	
	// Loads previous setup from disk.
	LoadSetup: function() {
		__INPUTCANDY.setup = __INPUTCANDY.e_load_file(__INPUTCANDY.setup_filename,__ICI.New_ICSetup());
	},
	
	Is_Valid_Setting: function (setting_index) {
		if ( setting_index == none ) return true;
		if ( setting_index < array_length(__INPUTCANDY.settings) and setting_index >= 0 ) return true;
	},
	
	Is_Valid_Device: function (device_index) {
		if ( device_index == none ) return true;
		if ( device_index < array_length(__INPUTCANDY.devices) and device_index >= 0 ) return true;
	},
	
	// Activate Setup applies device swapping, settings, call on "Frame 5", and only then. 
	ActivateSetup: function() {
		for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
			if ( !__ICI.Is_Valid_Setting(__INPUTCANDY.setup.settings[i]) ) {
				__INPUTCANDY.players[i].settings=none;
				if ( !__ICI.Is_Valid_Device(__INPUTCANDY.setup.devices[i]) ) __INPUTCANDY.players[i].device=none;
				continue;
			}
			if ( !__ICI.Is_Valid_Device(__INPUTCANDY.setup.devices[i]) ) {
				__INPUTCANDY.players[i].device=none;
				continue;
			}
			__INPUTCANDY.players[i].settings=__INPUTCANDY.setup.settings[i];
			__INPUTCANDY.players[i].device=__INPUTCANDY.setup.devices[i];
		}
	},
	
	// Updates the active setup based on current settings then saves it.
	UpdateActiveSetup: function () {
		__INPUTCANDY.setup=__ICI.CurrentSetup();
		__ICI.SaveSettings();
	},
	
	ApplySDLMappings: function () {
		for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
			var player=__INPUTCANDY.players[i];
			if ( player.device == none ) continue;
			var device=__INPUTCANDY.devices[__INPUTCANDY.players[i].device];
			gamepad_remove_mapping(device.slot_id);
			var mapping=gamepad_get_guid(device.slot_id) + "," + gamepad_get_description(device.slot_id) + ",";
			if ( player.settings != none ) {
				mapping+=__INPUTCANDY.settings[player.settings].deviceInfo.sdl.remapping;
			} else {
				mapping+=device.sdl.remapping;
			}
			gamepad_test_mapping(device.slot_id,mapping);
		}
	},
	
	ApplyDeviceSettings: function() {
		for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
			var player=__INPUTCANDY.players[i];
			if ( player.device == none ) continue;
			var device=__INPUTCANDY.devices[__INPUTCANDY.players[i].device];
			if ( player.settings >= 0 and player.settings < array_length(__INPUTCANDY.settings) ) {
				var settings=__INPUTCANDY.settings[player.settings];
				gamepad_set_axis_deadzone(device.slot_id,settings.deadzone1);
				gamepad_set_button_threshold(device.slot_id,settings.deadzone2);
			}
		}
	},

	/// WIP Network	
	New_ICNetwork: function() {
		return {
			peers: [],
			hosting: true
		};
	},
 
 };	 
}
