/* 
   Script assets for the Controls Setup screens.  Style your way by modifying.
    - This is written to be modal (for the device_select, gamepad_setup and control_binding screens)
    - It is also written to be responsive, where you can set the region of the screen,
      generally it is a good idea to keep this relatively square, but it is possible to adapt the
	  values in real time to whatever floats your boat.
 */
 
 // UI mode options for ..ui.mode(...)
#macro ICUI_none noone
#macro ICUI_error -1
#macro ICUI_device_select 0
#macro ICUI_SDLDB_select 1
#macro ICUI_gamepad_test 2
#macro ICUI_input_binding 3
#macro ICUI_capture 4

// UI signal options for ..ui.input(...)
#macro ICUI_up 0
#macro ICUI_down 1
#macro ICUI_left 2
#macro ICUI_right 3   
#macro ICUI_button 4   // any button pressed

function __Init_ICUI() {
	__INPUTCANDY.ui={
		exit_to: rm_InputCandy_testgame,
	    region: rectangle(128,128,room_width-256,room_height-256),   // Area of the screen for UI		
		mode: function () { // Query the UI's current mode, or set its mode
			 if ( argument_count <1 ) {
			 if ( __INPUTCANDY.ui.device_select.mode ) return ICUI_device_select;
			 if ( __INPUTCANDY.ui.SDLDB_select.mode ) return ICUI_SDLDB_select;
			 if ( __INPUTCANDY.ui.gamepad_test.mode ) return ICUI_gamepad_test;
			 if ( __INPUTCANDY.ui.input_binding.mode ) return ICUI_input_binding;
			 if ( __INPUTCANDY.ui.capture.mode ) return ICUI_capture;
			 return ICUI_error; // We weren't in any mode.
			} else { // Passing a number selects the mode
			 switch ( argument0 ) {
				 case ICUI_none: // Set no mode (clear mode), used by other mode setters
				  __INPUTCANDY.ui.device_select.mode=false;
				  __INPUTCANDY.ui.SDLDB_select.mode=false; 
				  __INPUTCANDY.ui.gamepad_test.mode=false;
				  __INPUTCANDY.ui.input_binding.mode=false;
				  __INPUTCANDY.ui.capture.mode=false;
				 break;
				 case ICUI_device_select:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.device_select.mode=true;
                 break;
				 case ICUI_SDLDB_select:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.SDLDB_select=true;
                 break;
				 case ICUI_gamepad_test:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.gamepad_test.mode=true;
                 break;
				 case ICUI_input_binding:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.input_binding.mode=true;
                 break;
				 case ICUI_input_capture:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.capture.mode=true;
                 break;				 
				 default: return false; break; // Couldn't set the mode.
			 }
             return true;
			}
		},
		expired: 0.0,  // seconds counter
		//////// UI Style and settings
		style: {
			high: 0.05,			// How tall elements are in a ratio to total size of the UI
			wide: 0.15,			// How wide elements are in a ratio to total size of the UI
			smidge: 0.01,       // Represents a small length used for spacers between things, etc.
			font: font_Jellee,  // Font used for UI elements
			text1: c_white,		// Color1 of text
			text2: c_white,		// Color2 of text
			text3: c_white,		// Color3 of text
			text4: c_white,		// Color4 of text
			label_w: 0.05,      // How wide the label is when paired with a text_in_box
			corner_x: 6,		// Corner radius of rectangles
			corner_y: 6,		// Corner radius of rectangles
			dim: 0.6,           // What a dim version of a color is
			shadow: 0.2,        // Amount of shadowed color that should be mixed with black
			rect_col1: c_white, // Rectangle color1
			rect_col2: c_gray,  // Rectangle color2
			box1: c_dkgray,		// Box interior color1 for input boxes
			box2: c_black,		// Box interior color2
			  //////// Slider
			slider_knob: 0.1,   // How wide the slider knob should be horizontally, 0.1 is good
			slider_groove: 0.8, // How tall the slider groove should be horizontally, 0.1-1.0
			slider1: c_white,   // Slider groove color1 for sliders
			slider2: c_gray,    // Slider groove color2
			knob1: c_green,     // Slider knob color1 for slider knobs
			knob2: c_green,     // Slider knob color2
			gp1: c_yellow,      // Gamepad highlight color1
			gp2: c_orange,      // Gamepad highlight color2
			backing1: c_aqua,   // UI button backing color1
			backing2: c_teal,   // UI button backing color2
			  //////// Influence Indicator
			highlight_thickness: 0.07,  // Thickness of the influence indicator
			highlight1: c_fuchsia, // Color1 of influence indicator
			highlight2: c_purple,  // Color2 of influence indicator
			pulse_highlight: true,  // Pulse the influence indicator
			pulse_speed_s: 1.3,     // Speed of the pulsing (in seconds)
			draw_3d_buttons: true,  // Draws a "Fake 3d" button instead of a flat button
			show_title: true,    // false if you are going to provide your own title/mode display
			  //////// Mouse support
			allow_mouse: false,        // When available, use the mouse.
			use_custom_cursor: true,   // Provide a mouse cursor.
			custom_mouse_cursor: s_InputCandy_ICUI_mouse_cursor,  // Use this one
			custom_mouse_cursor_tint: c_white   // Quickly change the look of the cursor
		},
		// UI mode where we're selecting a device for each player, this is the default mode
		device_select: {
			mode: true,
			inspecting: false, // Selecting next operation
			swapping: false,   // Swap gamepad menu
			influencing: 0,    // Which player are you influencing?
			menuitem: 0,       // Which menu item are you selecting?
			swapping_select: none,
			allow_multiple_players: false  // Allows multiple players to use the same gamepad
		},
		// UI mode where we're selecting a remapping from the SDL database
		SDLDB_select: {
			mode: false,
			influencing: 0,
			scrolled: 0         // How many elements we've scrolled down the list.
		},
		// UI mode where we're testing a gamepad (leads to SDLDB_select and input_binding)
		gamepad_test: {
			mode: false,
			influencing: 0
		},
		// UI mode where we're mapping controls for a gamepad or loading settings
		input_binding: {
			mode: false,
			influencing: 0,
			keyboard_and_mouse: false,
			loading: false,
			saving: false,
			scrolled: 0         // How many elements we've scrolled down the list.
		},
		// Special mode where we're capturing input.
		capture: {
			mode: false,        // True when we're capturing input.
			duration: 5.0,      // Hard time cutoff for capturing input.
			expired: 0.0,       // How long we've been attempting to capture.
		},
		// Assumptive UI signal check for global input on settings screens
		input: function ( kind ) {
			switch ( kind ) {
				case ICUI_left:    return __IC.SignalAnyReleased( IC_padl ) or keyboard_check_released(ord("A")) or keyboard_check_released( vk_left  ) or __IC.SignalAnyReleased( IC_hat0_L ) or __IC.SignalAnyReleased( IC_hat1_L ) or __IC.SignalAnyReleased( IC_hat2_L ) or __IC.SignalAnyReleased( IC_hat3_L ) or __IC.SignalAnyReleased( IC_hat4_L );
				case ICUI_right:   return __IC.SignalAnyReleased( IC_padr ) or keyboard_check_released(ord("D")) or keyboard_check_released( vk_right ) or __IC.SignalAnyReleased( IC_hat0_R ) or __IC.SignalAnyReleased( IC_hat1_R ) or __IC.SignalAnyReleased( IC_hat2_R ) or __IC.SignalAnyReleased( IC_hat3_R ) or __IC.SignalAnyReleased( IC_hat4_R );
				case ICUI_up:      return __IC.SignalAnyReleased( IC_padu ) or keyboard_check_released(ord("W")) or keyboard_check_released( vk_up    ) or __IC.SignalAnyReleased( IC_hat0_U ) or __IC.SignalAnyReleased( IC_hat1_U ) or __IC.SignalAnyReleased( IC_hat2_U ) or __IC.SignalAnyReleased( IC_hat3_U ) or __IC.SignalAnyReleased( IC_hat4_U );
				case ICUI_down:    return __IC.SignalAnyReleased( IC_padd ) or keyboard_check_released(ord("S")) or keyboard_check_released( vk_down  ) or __IC.SignalAnyReleased( IC_hat0_D ) or __IC.SignalAnyReleased( IC_hat1_D ) or __IC.SignalAnyReleased( IC_hat2_D ) or __IC.SignalAnyReleased( IC_hat3_D ) or __IC.SignalAnyReleased( IC_hat4_D );
				case ICUI_button:  return __IC.SignalAnyReleased( IC_A )    or __IC.SignalAnyReleased( IC_B )
				                       or keyboard_check_released( vk_control ) or keyboard_check_released(ord("Z"))
									   or keyboard_check_released(ord("X"))     or keyboard_check_released(ord("C"))
									   or keyboard_check_released( vk_enter )   or keyboard_check_released( vk_space )
									   or mouse_check_button_released(mb_any);
				default: return false;
			}
		}
	};
}

// Draws a slider for setting deadzone
function ICUI_slider( is_focused, value, increment, x, y, w, h ) {
	var knob_w=w*__INPUTCANDY.ui.style.slider_knob;
	var groove_h=h*__INPUTCANDY.ui.style.slider_groove;
	var groove_h_padding=(h-groove_h)/2.0;
	var knob_x=x+(w*value);
	if ( is_focused ) {
		var thickness=w*__INPUTCANDY.ui.style.highlight_thickness;
		if ( __INPUTCANDY.ui.style.pulse_highlight ) {
			var pulse = __INPUTCANDY.ui.expired % __INPUTCANDY.ui.style.pulse_speed_s / __INPUTCANDY.ui.style.pulse_speed_s;
			var rgb1=color_mult( __INPUTCANDY.ui.style.highlight1, pulse );
			var rgb2=color_mult( __INPUTCANDY.ui.style.highlight2, pulse );
			draw_roundrect_color_ext(x-thickness,y-thickness,x+w+thickness*2,y+h+thickness*2,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,rgb1,rgb2,false);
		} else {
			draw_roundrect_color_ext(x-thickness,y-thickness,x+w+thickness*2,y+h+thickness*2,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.highlight1,__INPUTCANDY.ui.style.highlight2,false);
		}
		if ( __INPUTCANDY.ui.input(ICUI_left) ) value -= increment;
		if ( __INPUTCANDY.ui.input(ICUI_right) ) value += increment;
	}
	draw_roundrect_color_ext(x,y+groove_h_padding,x+w,y+h-groove_h_padding*2,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.slider1,__INPUTCANDY.ui.style.slider2,false);
	draw_roundrect_color_ext(x+knob_x-knob_w/2,y,x+knob_x+knob_w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2,false);
	return value;
}

// Draws text is centered/middle
function ICUI_text( is_focused, text, x, y ) {
	if ( string_length(text) == 0 ) return;
	if ( is_focused ) {
		if ( __INPUTCANDY.ui.style.pulse_highlight ) {
			draw_text_transformed_color( x, y, text, __INPUTCANDY.ui.fw, __INPUTCANDY.ui.fh, 0.0, __INPUTCANDY.ui.style.text1, __INPUTCANDY.ui.style.text2, __INPUTCANDY.ui.style.text3, __INPUTCANDY.ui.style.text4, 1.0 );
			var pulse = __INPUTCANDY.ui.expired % __INPUTCANDY.ui.style.pulse_speed_s / __INPUTCANDY.ui.style.pulse_speed_s;
			draw_text_color( x, y, text, __INPUTCANDY.ui.style.highlight1, __INPUTCANDY.ui.style.highlight1, __INPUTCANDY.ui.style.highlight2, __INPUTCANDY.ui.style.highlight2, pulse );
		} else {
			draw_text_color( x, y, text, __INPUTCANDY.ui.style.highlight1, __INPUTCANDY.ui.style.highlight1, __INPUTCANDY.ui.style.highlight2, __INPUTCANDY.ui.style.highlight2, 1.0 );
		}
	} else {
		draw_text_color( x, y, text, __INPUTCANDY.ui.style.text1, __INPUTCANDY.ui.style.text2, __INPUTCANDY.ui.style.text3, __INPUTCANDY.ui.style.text4, 1.0 );
	}
}

// Draws "text in a box"
function ICUI_text_in_box( is_focused, text, x, y, w, h ) {
	if ( is_focused ) {
		var thickness=h*__INPUTCANDY.ui.style.highlight_thickness;
		if ( __INPUTCANDY.ui.style.pulse_highlight ) {
			var pulse = __INPUTCANDY.ui.expired % __INPUTCANDY.ui.style.pulse_speed_s / __INPUTCANDY.ui.style.pulse_speed_s;
			var rgb1=color_mult( __INPUTCANDY.ui.style.highlight1, pulse );
			var rgb2=color_mult( __INPUTCANDY.ui.style.highlight2, pulse );
			draw_roundrect_color_ext(x-thickness,y-thickness,x+w+thickness,y+h+thickness,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,rgb1,rgb2,false);
		} else {
			draw_roundrect_color_ext(x-thickness,y-thickness,x+w+thickness,y+h+thickness,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.highlight1,__INPUTCANDY.ui.style.highlight2,false);
		}
	}
	draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.box2,__INPUTCANDY.ui.style.box1,false);
	ICUI_text(false,text,x+w/2,y+h/2);
}

function ICUI_surround_button( is_focused, x, y, w, h ) {
	if ( is_focused ) {
		var thickness=h*__INPUTCANDY.ui.style.highlight_thickness;
		if ( __INPUTCANDY.ui.style.pulse_highlight ) {
			var pulse = __INPUTCANDY.ui.expired % __INPUTCANDY.ui.style.pulse_speed_s / __INPUTCANDY.ui.style.pulse_speed_s;
			var rgb1=color_mult( __INPUTCANDY.ui.style.highlight1, pulse );
			var rgb2=color_mult( __INPUTCANDY.ui.style.highlight2, pulse );
			draw_roundrect_color_ext(x-thickness,y-thickness,x+w+thickness,y+h+thickness,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,rgb1,rgb2,false);
		} else {
			draw_roundrect_color_ext(x-thickness,y-thickness,x+w+thickness,y+h+thickness,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.highlight1,__INPUTCANDY.ui.style.highlight2,false);
		}
	}
	draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.box2,__INPUTCANDY.ui.style.box1,false);
}

function ICUI_labeled_text_in_box( is_focused, text1, text2, x1, x2, y, w, h ) {
	ICUI_text( is_focused, text1, x1+(x2-x1)/2, y+h/2 );
	ICUI_text_in_box( is_focused, text2, x2, y, w, h );
}

function ICUI_labeled_button( is_focused, labeltext, x, y, w, h ) {
	var thickness=h*__INPUTCANDY.ui.style.highlight_thickness;
	var rgb1=color_mult( __INPUTCANDY.ui.style.box1, __INPUTCANDY.ui.style.shadow );
	var rgb2=color_mult( __INPUTCANDY.ui.style.box2, __INPUTCANDY.ui.style.shadow );	
	if ( __INPUTCANDY.ui.style.draw_3d_buttons ) draw_roundrect_color_ext(x+thickness,y+thickness,x+w+thickness,y+h+thickness,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,rgb1,rgb2,false);
	if ( is_focused ) {
		if ( __INPUTCANDY.ui.style.pulse_highlight ) {
			var pulse = __INPUTCANDY.ui.expired % __INPUTCANDY.ui.style.pulse_speed_s / __INPUTCANDY.ui.style.pulse_speed_s;
			rgb1=color_mult( __INPUTCANDY.ui.style.highlight1, pulse );
			rgb2=color_mult( __INPUTCANDY.ui.style.highlight2, pulse );
			draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.box2,__INPUTCANDY.ui.style.box1,false);
			draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,rgb1,rgb2,false);
		} else {
		draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.highlight1,__INPUTCANDY.ui.style.highlight2,false);
		}
	} else {
		draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.box2,__INPUTCANDY.ui.style.box1,false);
	}
	ICUI_text(false,labeltext,x+w/2,y+h/2);
}


// Draws a "button description" like A,B,X,Y,hat0_L,a key
function ICUI_draw_ICbutton( is_focused, label ) {
}


// Call in the Draw Step of an ICUI controller object, like o_ICUI
function ICUI_Draw() {
	__INPUTCANDY.ui.expired += 1.0/room_speed;
	var fontsize = font_get_size(__INPUTCANDY.ui.style.font);
	__INPUTCANDY.ui.fw = fontsize / __INPUTCANDY.ui.region.w * __INPUTCANDY.ui.style.wide;
	__INPUTCANDY.ui.fh = fontsize / __INPUTCANDY.ui.region.h * __INPUTCANDY.ui.style.high;
	
	var mode=__INPUTCANDY.ui.mode();
	
	switch ( mode ) {
		case ICUI_device_select: ICUI_Draw_device_select();	break;
		case ICUI_gamepad_test: ICUI_Draw_gamepad_test(); break;
		case ICUI_SDLDB_select: ICUI_Draw_SDLDB_select(); break;
		case ICUI_input_binding: ICUI_Draw_input_binding(); break;
		case ICUI_capture: ICUI_Draw_capture(); break;
		default: return false;
	}
	return true;
}


function ICUI_Draw_device_select() {
	
	var device_count=array_length(__INPUTCANDY.devices);
	
	if ( __INPUTCANDY.max_players == 1 and device_count == 0 ) { // Skip gamepad selection, go right to Keyboard/Mouse Input Binding
		__INPUTCANDY.ui.device_select.mode=false;
		__INPUTCANDY.ui.input_binding.mode=true;
		__INPUTCANDY.ui.input_binding.keyboard_mouse=true;
		return;
	}
	
	if ( __INPUTCANDY.ui.device_select.swapping ) { // This section is only drawn once you have opted to switch gamepads (menu option in selecting)
		ICUI_device_select_swapping();
		return;
	}
	
	var ox=__INPUTCANDY.ui.region.x;
	var oy=__INPUTCANDY.ui.region.y;
	var ew=__INPUTCANDY.ui.style.wide*__INPUTCANDY.ui.region.w;
	var eh=__INPUTCANDY.ui.style.high*__INPUTCANDY.ui.region.h;
	var smidge=__INPUTCANDY.ui.region.w*__INPUTCANDY.ui.style.smidge;
	var icon_sprite_wh=sprite_get_width(s_InputCandy_device_icons);
	var icon_scale=1.0/icon_sprite_wh;
	var fontsize=eh;
	var oldfont = draw_get_font();
	var oldhalign = draw_get_halign();
	var oldvalign = draw_get_valign();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(__INPUTCANDY.ui.style.font);
	
	if ( __INPUTCANDY.ui.style.show_title ) {
		oy+=eh;
		ICUI_text( false, "Choose Device and Configure Controls", ox+__INPUTCANDY.ui.region.w/2, oy );
		oy+=smidge+eh*2;
	}	
	
	var rows=2,cols=2;
	switch ( __INPUTCANDY.max_players ) {
		case 0: case 1: rows=1; cols=1; break;
		case 2: rows=1; cols=2; break;
		case 3: rows=1; cols=3; break;
		case 4: rows=2; cols=2; break;
		case 5: rows=3; cols=2; break;
		case 6: rows=2; cols=3; break;
		case 7: case 8: rows=2; cols=4; break;
		case 9: rows=3; cols=3; break;
		case 10: case 11:case 12: rows=4; cols=3; break;
		case 13: case 14: case 15: case 16: rows=4; cols=4; break;
		case 17: case 18: case 19: case 20: rows=4; cols=5; break;
		default: rows=5; cols=5; break;
	}
	
	if ( __INPUTCANDY.ui.region.w < __INPUTCANDY.ui.region.h ) {
		var temp=rows;
		rows=cols;
		cols=temp;
	}
	
	var cw=__INPUTCANDY.ui.region.w/cols;
	var rh=(__INPUTCANDY.ui.region.y2-oy)/rows;
	var swh=min(cw,rh);
	var r;
	
	for ( var k=0; k<__INPUTCANDY.max_players; k++ ) {
		ICUI_text( false, "Player "+int(k+1), ox+cw/2, oy );
		if ( !__INPUTCANDY.ui.device_select.inspecting ) {
		    r=rectangle(ox+cw/2-cw*0.375, oy+rh/2-rh*0.375, cw*0.75, rh*0.75);	
			if ( cwithin(mouse_x,mouse_y,r) ) {__INPUTCANDY.ui.device_select.menuitem=0; __INPUTCANDY.ui.device_select.influencing=k;}
			ICUI_surround_button( 
			 ( __INPUTCANDY.ui.device_select.influencing == k and __INPUTCANDY.ui.device_select.menuitem == 0 ),
			 r.x,r.y,r.w,r.h );
		}
		if ( __INPUTCANDY.keyboard_mouse_player1 and k==0 ) {
			draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(__INPUTCANDY.devices[__INPUTCANDY.players[k].device]),ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.75, 0, c_white, 1.0 );
			draw_sprite_ext( s_InputCandy_device_icons, 0,ox+cw/2+cw/4,oy+rh/2+rh/4, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.25, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.25, 0, c_white, 1.0 );
		} else
		draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(__INPUTCANDY.players[k].device==none?none:__INPUTCANDY.devices[__INPUTCANDY.players[k].device]),ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.75, 0, c_white, 1.0 );
		if ( __INPUTCANDY.players[k].device != none )
		ICUI_text( false, "Slot #"+int(__INPUTCANDY.players[k].device+1), ox+cw/4, oy+rh-rh/5 );
		ox += cw;
		if ( ox >= __INPUTCANDY.ui.region.x2-cw/2 ) {
			ox = __INPUTCANDY.ui.region.x;
			oy += rh;
		}
	}
	
	
	
	if ( __INPUTCANDY.ui.device_select.inspecting ) {	// This section is only drawn once you have selected a player
		
		var player_index=__INPUTCANDY.ui.device_select.influencing;
		var player=__INPUTCANDY.players[player_index]
		var device=player.device == none ? none : __INPUTCANDY.devices[player.device];
		
		var subwindow_margin=0.1*__INPUTCANDY.ui.region.h;
		var region=rectangle( __INPUTCANDY.ui.region.x+subwindow_margin, __INPUTCANDY.ui.region.y+subwindow_margin,
                              __INPUTCANDY.ui.region.w-subwindow_margin*2, __INPUTCANDY.ui.region.h-subwindow_margin*2 );
		ICUI_text_in_box( false, "", region.x, region.y, region.w, region.h );

		var sx=region.x;
		var sy=region.y;
		ICUI_text( false, "Player "+int(__INPUTCANDY.ui.device_select.influencing+1), region.x+region.w/2, sy+eh );
		
		r=rectangle(region.x, region.y, eh*2, eh*2);
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=0;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == 0, "", r.x,r.y,r.w,r.h );
		draw_sprite_ext(s_InputCandy_ICUI_icons,0,region.x+eh,region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);
		
		var menu_margin=0.1*region.w;
		var btn_width=region.w-menu_margin*2;
		var btn_height=region.h/12;
		
		sy+=btn_height;
		
		var topregion = rectangle( region.x+menu_margin, sy, btn_width, 4*btn_height );
		var rightside = rectangle ( region.x+topregion.h, topregion.y, topregion.w-topregion.h, topregion.h );
		
		if ( device != none ) {
			draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(device), topregion.x + topregion.h/2, topregion.y + topregion.h/2,
				1.0/sprite_get_width(s_InputCandy_device_icons)*cw*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*rh*0.75, 0, c_white, 1.0 );
			draw_set_halign(fa_left);
			ICUI_text( false,
				"Gamepad: "+device.desc+" (Slot #"+int(player.device+1)+")\n"
			   +"GUID: "+device.guid+"\n"
			   +"Buttons: "+int(device.button_count)+"   Axis: "+int(device.axis_count)+"   Hats: "+int(device.hat_count)+"\n"
		       +"SDL Name: "+device.sdl.name+"\n"
			   +"SDL DB matched? "+(string_length(device.sdl.remapping)>0?"Yes":"No")+"\n"
			   +"SDL Mapping Active:\n"+device.SDL_Mapping,
			 rightside.x+rightside.w/2, rightside.y+rightside.h/2
			);
			draw_set_halign(fa_center);
		}
		
		sx = menu_margin+region.x;
		var max_menuitem=4;
		sy += 5*btn_height+btn_height/5;
		r =rectangle( sx, sy, btn_width, btn_height );
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=1;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == 1, "Select Different Gamepad", r.x,r.y,r.w,r.h );
		sy += btn_height+btn_height/5;
		r =rectangle( sx, sy, btn_width, btn_height );
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=2;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == 2, "Customize Gamepad Input", r.x,r.y,r.w,r.h );
		sy += btn_height+btn_height/5;
		r =rectangle( sx, sy, btn_width, btn_height );
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=3;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == 3, "Pick Gamepad SDL Remapping", r.x,r.y,r.w,r.h );
		sy += btn_height+btn_height/5;
		r =rectangle( sx, sy, btn_width, btn_height );
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=4;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == 4, "Test on Gamepad Simulator", r.x,r.y,r.w,r.h );
		
		if ( player_index == 0 ) {
			var kms="Keyboard and Mouse Settings";
			if ( device.type == ICDeviceType_keyboard ) kms="Keyboard Settings";
			else if ( device.type == ICDeviceType_mouse ) kms="Mouse Settings";
			max_menuitem=5;
			sy += btn_height+btn_height/5;
			r =rectangle( sx, sy, btn_width, btn_height );
			if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=5;
			ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == 5, kms, r.x,r.y,r.w,r.h );
		}		

		if ( __INPUTCANDY.ui.input(ICUI_right) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem++;
			if ( __INPUTCANDY.ui.device_select.menuitem > max_menuitem ) __INPUTCANDY.ui.device_select.menuitem=0;
		}
		if ( __INPUTCANDY.ui.input(ICUI_left) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem--;
			if ( __INPUTCANDY.ui.device_select.menuitem < 0 ) __INPUTCANDY.ui.device_select.menuitem=max_menuitem;
		}
		if ( __INPUTCANDY.ui.input(ICUI_up) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem--;
			if ( __INPUTCANDY.ui.device_select.menuitem < 0 ) __INPUTCANDY.ui.device_select.menuitem=max_menuitem;
		}
		if ( __INPUTCANDY.ui.input(ICUI_down) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem++;
			if ( __INPUTCANDY.ui.device_select.menuitem > max_menuitem ) __INPUTCANDY.ui.device_select.menuitem=0;
		}
		if( __INPUTCANDY.ui.input(ICUI_button) ) {
		 	audio_play_sound(a_ICUI_tone,100,0);
			switch ( __INPUTCANDY.ui.device_select.menuitem ) {
				case 0:
				audio_play_sound(a_ICUI_pageflip,100,0);
			 	 __INPUTCANDY.ui.device_select.inspecting=false;
				break;
				case 1:
				audio_play_sound(a_ICUI_tone,100,0);
				 __INPUTCANDY.ui.device_select.swapping_select=0;
 				 __INPUTCANDY.ui.device_select.swapping=true;
				 __INPUTCANDY.ui.device_select.menuitem=0;
				break;
				case 2:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.input_binding.mode=true;
				 __INPUTCANDY.ui.input_binding.keyboard_mouse=false;
				break;
				case 3:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.SDLDB_select=true;
				break;
				case 4:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.gamepad_test=true;
				break;
				case 5:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.input_binding.mode=true;
				 __INPUTCANDY.ui.input_binding.keyboard_mouse=true;
				break;
			}
		}
	} else { // Controls have focus on background window
		
		var max_menuitem=__INPUTCANDY.max_players;
		
		// Back Button for background area of device_select (returns to ui's exit area
		r=rectangle(__INPUTCANDY.ui.region.x2-eh*2, __INPUTCANDY.ui.region.y, eh*2, eh*2);
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.influencing=max_menuitem;		
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.influencing == max_menuitem, "", r.x,r.y,r.w,r.h );
		
		draw_sprite_ext(s_InputCandy_ICUI_icons,0,
		  __INPUTCANDY.ui.region.x2-eh,__INPUTCANDY.ui.region.y+eh,
		  icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);
		
		if ( __INPUTCANDY.ui.input(ICUI_right) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem=0;
			__INPUTCANDY.ui.device_select.influencing= (__INPUTCANDY.ui.device_select.influencing+1)%(max_menuitem+1);
		}
		if ( __INPUTCANDY.ui.input(ICUI_left) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem=0;
			__INPUTCANDY.ui.device_select.influencing-=1;
			if (__INPUTCANDY.ui.device_select.influencing< 0) __INPUTCANDY.ui.device_select.influencing=max_menuitem;
		}
		if ( __INPUTCANDY.ui.input(ICUI_up) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem=0;
			__INPUTCANDY.ui.device_select.influencing-=cols;
			while (__INPUTCANDY.ui.device_select.influencing< 0) __INPUTCANDY.ui.device_select.influencing+=__INPUTCANDY.max_players;
			if ( __INPUTCANDY.ui.device_select.influencing > __INPUTCANDY.max_players )
				__INPUTCANDY.ui.device_select.influencing= (__INPUTCANDY.ui.device_select.influencing+cols)%(max_menuitem+1);
		
		}
		if ( __INPUTCANDY.ui.input(ICUI_down) ) {
			audio_play_sound(a_ICUI_click,100,0);
			__INPUTCANDY.ui.device_select.menuitem=0;
			__INPUTCANDY.ui.device_select.influencing= (__INPUTCANDY.ui.device_select.influencing+cols)%(max_menuitem+1);
		}
		if( __INPUTCANDY.ui.input(ICUI_button) ) {
			audio_play_sound(a_ICUI_tone,100,0);
			if ( __INPUTCANDY.ui.device_select.influencing < __INPUTCANDY.max_players ) {
			__INPUTCANDY.ui.device_select.inspecting=true;
			__INPUTCANDY.ui.device_select.menuitem=0;
			} else {
				audio_play_sound(a_ICUI_pageflip,100,0);
				room_goto(__INPUTCANDY.ui.exit_to);
			}				
		}
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_device_select_swapping() {
		
	var device_count=array_length(__INPUTCANDY.devices);
    var max_menuitem=device_count+1;
	
	var ox=__INPUTCANDY.ui.region.x;
	var oy=__INPUTCANDY.ui.region.y;
	var ew=__INPUTCANDY.ui.style.wide*__INPUTCANDY.ui.region.w;
	var eh=__INPUTCANDY.ui.style.high*__INPUTCANDY.ui.region.h;
	var smidge=__INPUTCANDY.ui.region.w*__INPUTCANDY.ui.style.smidge;
	var icon_sprite_wh=sprite_get_width(s_InputCandy_device_icons);
	var icon_scale=1.0/icon_sprite_wh;
	var fontsize=eh;
	var oldfont = draw_get_font();
	var oldhalign = draw_get_halign();
	var oldvalign = draw_get_valign();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(__INPUTCANDY.ui.style.font);
		
	// Draws a background
	ICUI_text_in_box( false, "", __INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, __INPUTCANDY.ui.region.w, __INPUTCANDY.ui.region.h );

	var sx=__INPUTCANDY.ui.region.x;
	var sy=__INPUTCANDY.ui.region.y;

	// Back Button
	var r=rectangle(__INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, eh*2, eh*2);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.swapping_select=max_menuitem;
	ICUI_labeled_button( __INPUTCANDY.ui.device_select.swapping_select == max_menuitem, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Player "+int(__INPUTCANDY.ui.device_select.influencing+1)+"\nChoose Gamepad", ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=smidge+eh*2;
	
	var rows=2,cols=2;
	switch ( device_count ) {
		case 0: case 1: rows=1; cols=1; break;
		case 2: rows=1; cols=2; break;
		case 3: rows=1; cols=3; break;
		case 4: rows=2; cols=2; break;
		case 5:
		case 6:
		case 7:
		case 8:
		case 9: rows=3; cols=3; break;
		case 10: case 11:case 12: rows=4; cols=3; break;
		case 13: case 14: case 15: case 16: rows=4; cols=4; break;
		case 17: case 18: case 19: case 20: rows=4; cols=5; break;
		default: rows=5; cols=5; break;
	}
	
	if ( __INPUTCANDY.ui.region.w < __INPUTCANDY.ui.region.h ) {
		var temp=rows;
		rows=cols;
		cols=temp;
	}
	
	var cw=__INPUTCANDY.ui.region.w/cols;
	var rh=(__INPUTCANDY.ui.region.y2-oy)/rows;
	var swh=min(cw,rh);
	var r;
	
	for ( var k=0; k<device_count; k++ ) {
	    r=rectangle(ox+cw/2-cw*0.375, oy+rh/2-rh*0.375, cw*0.75, rh*0.75);	
		if ( cwithin(mouse_x,mouse_y,r) ) {__INPUTCANDY.ui.device_select.swapping_select=k;}
		ICUI_surround_button( __INPUTCANDY.ui.device_select.swapping_select == k, r.x,r.y,r.w,r.h );
		
		r=rectangle( ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.75 );
		draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(__INPUTCANDY.devices[k]), r.x,r.y,r.w,r.h, 0, c_white, 1.0 );
		ICUI_text( false, "Slot #"+int(k), ox+cw/4, oy+rh-rh/5 );
		ox += cw;
		if ( ox >= __INPUTCANDY.ui.region.x2-cw/2 ) {
			ox = __INPUTCANDY.ui.region.x;
			oy += rh;
		}
	}

	if ( __INPUTCANDY.ui.input(ICUI_right) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.device_select.swapping_select++;
		if ( __INPUTCANDY.ui.device_select.swapping_select > max_menuitem ) __INPUTCANDY.ui.device_select.swapping_select=0;
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.device_select.swapping_select--;
		if ( __INPUTCANDY.ui.device_select.swapping_select < 0 ) __INPUTCANDY.ui.device_select.swapping_select=max_menuitem;
	}
	if ( __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.device_select.swapping_select--;
		if ( __INPUTCANDY.ui.device_select.swapping_select < 0 ) __INPUTCANDY.ui.device_select.swapping_select=max_menuitem;
	}
	if ( __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.device_select.swapping_select++;
		if ( __INPUTCANDY.ui.device_select.swapping_select > max_menuitem ) __INPUTCANDY.ui.device_select.swapping_select=0;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.device_select.swapping_select ) {
			case max_menuitem: // Abort / go back / cancel
		 	 __INPUTCANDY.ui.device_select.swapping=false;
			break;
			default:
				var device_in_use_by=none;
				for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
					if ( __INPUTCANDY.players[i].device == __INPUTCANDY.ui.device_select.swapping_select and i != __INPUTCANDY.ui.device_select.influencing )
						{ device_in_use_by=i; break; }
				}
				if ( device_in_use_by != none ) {
					var your_device=__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device;
					__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device=__INPUTCANDY.players[device_in_use_by].device;
					__INPUTCANDY.players[device_in_use_by].device=your_device;
				} else {
					__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device=__INPUTCANDY.ui.device_select.swapping_select;
				}
				__INPUTCANDY.ui.device_select.swapping=false;
				audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	}		
	
}

function ICUI_Draw_input_binding() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}

function ICUI_Draw_SDLDB_select() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}

function ICUI_Draw_gamepad_test() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}

function ICUI_Draw_capture() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}
