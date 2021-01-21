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
		//////// UI Style
		style: {
		    region: rectangle(128,128,room_width-256,room_height-256),   // Area of the screen for UI
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
			box1: c_gray,		// Box interior color1 for input boxes
			box2: c_dkgray,		// Box interior color2
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
			highlight_thickness: 0.05,  // Thickness of the influence indicator
			highlight1: c_fuchsia, // Color1 of influence indicator
			highlight2: c_purple,  // Color2 of influence indicator
			pulse_highlight: true,  // Pulse the influence indicator
			pulse_speed_s: 1.5,     // Speed of the pulsing (in seconds)
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
			selecting: false,
			influencing: 0,
			menuitem: 0,
			allow_multiple_players: false  // Allows multiple players to use the same gamepad
		},
		// UI mode where we're testing a gamepad (leads to SDLDB_select and input_binding)
		gamepad_test: {
			mode: false,
			influencing: 0
		},
		// UI mode where we're selecting a remapping from the SDL database
		SDLDB_select: {
			mode: false,
			influencing: 0,     
			scrolled: 0         // How many elements we've scrolled down the list.
		},
		// UI mode where we're mapping controls for a gamepad or loading settings
		input_binding: {
			mode: false,
			influencing: 0,
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
				case ICUI_left:    return __IC.SignalAnyReleased( IC_padl ) or __IC.SignalAnyReleased( IC_key_A ) or __IC.SignalAnyReleased( IC_key_arrow_L ) or __IC.SignalAnyReleased( IC_hat0_L ) or __IC.SignalAnyReleased( IC_hat1_L ) or __IC.SignalAnyReleased( IC_hat2_L ) or __IC.SignalAnyReleased( IC_hat3_L ) or __IC.SignalAnyReleased( IC_hat4_L );
				case ICUI_right:   return __IC.SignalAnyReleased( IC_padr ) or __IC.SignalAnyReleased( IC_key_D ) or __IC.SignalAnyReleased( IC_key_arrow_R ) or __IC.SignalAnyReleased( IC_hat0_R ) or __IC.SignalAnyReleased( IC_hat1_R ) or __IC.SignalAnyReleased( IC_hat2_R ) or __IC.SignalAnyReleased( IC_hat3_R ) or __IC.SignalAnyReleased( IC_hat4_R );
				case ICUI_up:      return __IC.SignalAnyReleased( IC_padu ) or __IC.SignalAnyReleased( IC_key_W ) or __IC.SignalAnyReleased( IC_key_arrow_U ) or __IC.SignalAnyReleased( IC_hat0_U ) or __IC.SignalAnyReleased( IC_hat1_U ) or __IC.SignalAnyReleased( IC_hat2_U ) or __IC.SignalAnyReleased( IC_hat3_U ) or __IC.SignalAnyReleased( IC_hat4_U );
				case ICUI_down:    return __IC.SignalAnyReleased( IC_padd ) or __IC.SignalAnyReleased( IC_key_S ) or __IC.SignalAnyReleased( IC_key_arrow_D ) or __IC.SignalAnyReleased( IC_hat0_D ) or __IC.SignalAnyReleased( IC_hat1_D ) or __IC.SignalAnyReleased( IC_hat2_D ) or __IC.SignalAnyReleased( IC_hat3_D ) or __IC.SignalAnyReleased( IC_hat4_D );
				case ICUI_button:  return __IC.SignalAnyReleased( IC_A )    or __IC.SignalAnyReleased( IC_B )     or __IC.SignalAnyReleased( IC_rctrl )
				                       or __IC.SignalAnyReleased( IC_lctrl) or __IC.SignalAnyReleased( IC_key_Z ) or __IC.SignalAnyReleased( IC_key_X )
									   or __IC.SignalAnyReleased( IC_enter) or __IC.SignalAnyReleased( IC_space );
				default: return false;
			}
		}
	};
}


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

// this text is centered
function ICUI_text( is_focused, text, x, y ) {
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

function ICUI_text_in_box( is_focused, text, x, y, w, h ) {
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
	}
	draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.box1,__INPUTCANDY.ui.style.box2,false);
	ICUI_text(false,text,x+w/2,y+h/2);
}

function ICUI_labeled_text_in_box( is_focused, text1, text2, x1, x2, y, w, h ) {
	ICUI_text( is_focused, text1, x1+(x2-x1)/2, y+h/2 );
	ICUI_text_in_box( is_focused, text2, x2, y, w, h );
}

function ICUI_labeled_button( is_focused, labeltext, x, y, w, h ) {
	ICUI_text_in_box( is_focused, labeltext, x, y, w, h );
}




// Call in the Draw Step of an ICUI controller object, like o_ICUI
function ICUI_Draw() {
	__INPUTCANDY.ui.expired += 1.0/room_speed;
	var fontsize = font_get_size(__INPUTCANDY.ui.style.font);
	__INPUTCANDY.ui.fw = fontsize / __INPUTCANDY.ui.style.region.w * __INPUTCANDY.ui.style.wide;
	__INPUTCANDY.ui.fh = fontsize / __INPUTCANDY.ui.style.region.h * __INPUTCANDY.ui.style.high;
	
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
	var ox=__INPUTCANDY.ui.style.region.x;
	var oy=__INPUTCANDY.ui.style.region.y;
	var ew=__INPUTCANDY.ui.style.wide*__INPUTCANDY.ui.style.region.w;
	var eh=__INPUTCANDY.ui.style.high*__INPUTCANDY.ui.style.region.h;
	var smidge=__INPUTCANDY.ui.style.region.w*__INPUTCANDY.ui.style.smidge;
	var fontsize=eh;
	var oldfont = draw_get_font();
	var oldhalign = draw_get_halign();
	var oldvalign = draw_get_valign();
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_font(__INPUTCANDY.ui.style.font);
	
	if ( __INPUTCANDY.ui.style.show_title ) {
		oy+=eh;
		ICUI_text( false, "Select Controller", ox+ew/2, oy );
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
	
	if ( __INPUTCANDY.ui.style.region.w < __INPUTCANDY.ui.style.region.h ) {
		var temp=rows;
		rows=cols;
		cols=temp;
	}
	
	var cw=__INPUTCANDY.ui.style.region.w/cols;
	var rh=(__INPUTCANDY.ui.style.region.y2-oy)/rows;
	
	for ( var k=0; k<__INPUTCANDY.max_players; k++ ) {
		ICUI_text( false, "Player "+int(k+1), ox+cw/2, oy );
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.influencing == k and __INPUTCANDY.ui.device_select.menuitem == 0, "", ox+cw/2-cw*0.375, oy+rh/2-rh*0.375, cw*0.75, rh*0.75 );
		if ( __INPUTCANDY.keyboard_mouse_gamepad1_same and __INPUTCANDY.players[k].device == ICDeviceType_keyboard_mouse ) {
			draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(__INPUTCANDY.devices[__INPUTCANDY.players[k].device]),ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*cw*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*rh*0.75, 0, c_white, 1.0 );
			draw_sprite_ext( s_InputCandy_device_icons, 0,ox+cw/2+cw/4,oy+rh/2+rh/4, 1.0/sprite_get_width(s_InputCandy_device_icons)*cw*0.25, 1.0/sprite_get_height(s_InputCandy_device_icons)*rh*0.25, 0, c_white, 1.0 );
		} else
		draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(__INPUTCANDY.players[k].device==none?none:__INPUTCANDY.devices[__INPUTCANDY.players[k].device]),ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*cw*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*rh*0.75, 0, c_white, 1.0 );
		if ( __INPUTCANDY.players[k].device != none )
		ICUI_text( false, "#"+int(__INPUTCANDY.players[k].device), ox+cw-ew, oy+rh-eh );
		ox += cw;
		if ( ox >= __INPUTCANDY.ui.style.region.x2-cw/2 ) {
			ox = __INPUTCANDY.ui.style.region.x;
			oy += rh;
		}
	}
	
	if ( __INPUTCANDY.ui.input(ICUI_right) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.device_select.menuitem=0;
		__INPUTCANDY.ui.device_select.influencing= (__INPUTCANDY.ui.device_select.influencing+1)%__INPUTCANDY.max_players;
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.device_select.menuitem=0;
		__INPUTCANDY.ui.device_select.influencing-=1;
		if (__INPUTCANDY.ui.device_select.influencing< 0) __INPUTCANDY.ui.device_select.influencing=__INPUTCANDY.max_players-1;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
		audio_play_sound(a_ICUI_tone,100,0);
		__INPUTCANDY.ui.device_select.selecting=true;
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_gamepad_test() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}

function ICUI_Draw_SDLDB_select() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}

function ICUI_Draw_input_binding() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}

function ICUI_Draw_capture() {
	if ( __INPUTCANDY.ui.style.show_title ) {
	}
}
