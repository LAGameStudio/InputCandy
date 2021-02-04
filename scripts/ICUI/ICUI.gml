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
			slider_groove: 0.5, // How tall the slider groove should be horizontally, 0.1-1.0
			slider1: c_black,   // Slider groove color1 for sliders
			slider2: c_dkgray,  // Slider groove color2
			knob1: c_white,     // Slider knob color1 for slider knobs
			knob2: c_dkgray,    // Slider knob color2
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
			scrolled: 0,			// How many elements we've scrolled down the list.
			choosing: false,         // Set to default?  Pick input from list?  Capture input?  Cancel?
			choosing_select: 0,
			choosing_action: none,
			choosing_pick: false,
			choosing_pick_select: 0,
			choosing_pick_scrolled: 0,
			choosing_capture: false,
			choosing_capture_expired: 0.0,			
			choosing_capture_2: false,				// For choosing axis
			choosing_capture_confirming: false,
			choosing_capture_select: 0,
			loading: false,          // Set profile from list
			loading_select: 0,
			loading_scrolled: 0,
			confirm_exit: false,
			confirm_exit_message: ""
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
	var groove_pad=(h-groove_h)/2.0;
	var knob_x=(w*value);
	var smidge=w*__INPUTCANDY.ui.style.highlight_thickness/2;
	if ( is_focused ) {
		if ( __INPUTCANDY.ui.style.pulse_highlight ) {
			var pulse = __INPUTCANDY.ui.expired % __INPUTCANDY.ui.style.pulse_speed_s / __INPUTCANDY.ui.style.pulse_speed_s;
			var rgb1=color_mult( __INPUTCANDY.ui.style.highlight1, pulse );
			var rgb2=color_mult( __INPUTCANDY.ui.style.highlight2, pulse );
			draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,rgb1,rgb2,false);
		} else {
			draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.highlight1,__INPUTCANDY.ui.style.highlight2,false);
		}
	}
	draw_roundrect_color_ext(x,y+groove_pad,x+w,y+groove_pad+groove_h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.slider1,__INPUTCANDY.ui.style.slider2,false);
	draw_roundrect_color_ext(x+knob_x-knob_w/2,y,x+knob_x+knob_w/2,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2,false);
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

// Draws text is centered/middle
function ICUI_text_color( c1,c2,c3,c4, text, x, y ) {
	if ( string_length(text) == 0 ) return;
	draw_text_color( x, y, text, c1,c2,c3,c4, 1.0 );
}
	
	
function ICUI_box( x, y, w, h ) {
	draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,__INPUTCANDY.ui.style.box2,__INPUTCANDY.ui.style.box1,false);
}

function ICUI_tinted_box( tint1, tint2, x, y, w, h ) {
	draw_roundrect_color_ext(x,y,x+w,y+h,__INPUTCANDY.ui.style.corner_x,__INPUTCANDY.ui.style.corner_y,tint1,tint2,false);
}

function ICUI_fit_image( sprite, index, x, y, w, h, tint, scale, rotation, alpha ) {
	var swh=min(w,h);
	draw_sprite_ext( sprite, index, x+w/2, y+h/2, 1.0/sprite_get_width(sprite)*swh*scale, 1.0/sprite_get_height(sprite)*swh*scale, rotation, tint, alpha );
}

function ICUI_image( sprite, index, x, y, w, h, tint, rotation, alpha ) {
	draw_sprite_ext( sprite, index, x+w/2, y+h/2, 1.0/sprite_get_width(sprite)*w, 1.0/sprite_get_height(sprite)*h, rotation, tint, alpha );
}

function ICUI_margin_image( sprite, index, x, y, w, h, tint, margin, alpha ) {
	draw_sprite_ext( sprite, index, x+w/2, y+h/2, 1.0/sprite_get_width(sprite)*w*margin, 1.0/sprite_get_height(sprite)*h*margin, 0, tint, alpha );
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
function ICUI_draw_ICaction( codes, deviceType, is_directional, is_combo, key_mouse_combo, r ) {
	
	var c=codes;
	
	if ( !is_array(c) ) {
		c=[c];
	}
	
	var fontsize = font_get_size(__INPUTCANDY.ui.style.font);
	
	var len=array_length(c);
	
	var swh=r.h;
	var spacing=swh/4;
	
	var sx=r.x;
	var sy=r.y+r.h/2;
	
	for( var i=0; i<len; i++ ) {
		var code=(!is_directional and c[i] < array_length(__INPUTCANDY.signals)) ? __INPUTCANDY.signals[c[i]].code : c[i];
		switch ( deviceType ) {
			case ICDeviceType_gamepad:
				if ( is_directional ) {
					if ( code == IC_dpad ) {
					  ICUI_image( s_InputCandy_ICUI_icons, 4, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  ICUI_image( s_InputCandy_ICUI_icons, 5, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  ICUI_image( s_InputCandy_ICUI_icons, 6, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  ICUI_image( s_InputCandy_ICUI_icons, 7, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  ICUI_image( s_InputCandy_ICUI_icons, 8, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  sx+=swh+spacing;
					} else if ( code >= IC_hat0 and code <= IC_hat9 ) {
                      var hatnum=code-IC_hat0;
					  ICUI_image( s_InputCandy_ICUI_icons, 16, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  if( hatnum > 0 ) ICUI_text_color( c_white, c_white, c_white, c_white, "#"+int(hatnum), sx+swh+spacing+fontsize, sy);
					  sx+=swh+spacing+fontsize*2;
					} else if ( code >= IC_axis0 and code <= IC_axis9 ) {
                      var axisnum=code-IC_axis0;
					  ICUI_image( s_InputCandy_ICUI_icons, 17, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					  if( axisnum > 0 ) ICUI_text_color( c_white, c_white, c_white, c_white, "#"+int(axisnum), sx+swh+spacing+fontsize, sy);
					  sx+=swh+spacing+fontsize*2;
					}
				} else if ( code == IC_padl ) {
				  ICUI_image( s_InputCandy_ICUI_icons, 4, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  ICUI_image( s_InputCandy_ICUI_icons, 5, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  sx+=swh+spacing;
				} else if ( code == IC_padr ) {
				  ICUI_image( s_InputCandy_ICUI_icons, 4, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  ICUI_image( s_InputCandy_ICUI_icons, 6, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  sx+=swh+spacing;
				} else if ( code == IC_padu ) {
				  ICUI_image( s_InputCandy_ICUI_icons, 4, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  ICUI_image( s_InputCandy_ICUI_icons, 7, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  sx+=swh+spacing;
				} else if ( code == IC_padd ) {
				  ICUI_image( s_InputCandy_ICUI_icons, 4, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  ICUI_image( s_InputCandy_ICUI_icons, 8, sx, r.y, swh, r.h, c_white, 0, 1.0 );
				  sx+=swh+spacing;
				} else if ( code >= IC_hat0_U and code <= IC_hat4_R ) {
					var d=(code-IC_hat0_U) % 4;
					var index=5;
					var hatnum=1;
					if (code >= IC_hat0_U and code <= IC_hat0_R) hatnum=0;
					else if (code >= IC_hat1_U and code <= IC_hat1_R) hatnum=1;
					else if (code >= IC_hat2_U and code <= IC_hat2_R) hatnum=2;
					else if (code >= IC_hat3_U and code <= IC_hat3_R) hatnum=3;
					switch ( d ) {
						case 0: break;
						case 1: index=6; break;
						case 2: index=7; break;
						case 3: index=8; break;
					}
					ICUI_image( s_InputCandy_ICUI_icons, 17, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					ICUI_image( s_InputCandy_ICUI_icons, index, sx, r.y, swh, r.h, c_white, 0, 1.0 );
                    if( hatnum > 0 ) ICUI_text_color( c_white, c_white, c_white, c_white, "#"+int(hatnum), sx+swh+spacing+fontsize, sy);
					sx+=swh+spacing+fontsize*2;
				} else if ( code == IC_Lshoulder ) {
					ICUI_image( s_InputCandy_ICUI_icons, 20, sx, r.y, swh, r.h, c_white, 0, 1.0 );					
					sx+=swh+spacing;
				} else if ( code == IC_Rshoulder ) {
					ICUI_image( s_InputCandy_ICUI_icons, 21, sx, r.y, swh, r.h, c_white, 0, 1.0 );					
					sx+=swh+spacing;
				} else if ( code == IC_Ltrigger ) {
					ICUI_image( s_InputCandy_ICUI_icons, 18, sx, r.y, swh, r.h, c_white, 0, 1.0 );					
					sx+=swh+spacing;
				} else if ( code == IC_Rtrigger ) {
					ICUI_image( s_InputCandy_ICUI_icons, 19, sx, r.y, swh, r.h, c_white, 0, 1.0 );					
					sx+=swh+spacing;
				} else if ( code == IC_Lstick ) {
					ICUI_image( s_InputCandy_ICUI_icons, 52, sx, r.y, swh, r.h, c_white, 0, 1.0 );
                    ICUI_text_color( c_white, c_white, c_white, c_white, "L", sx+swh+spacing, sy);
					sx+=swh+spacing+fontsize;
				} else if ( code == IC_Rstick ) {
					ICUI_image( s_InputCandy_ICUI_icons, 52, sx, r.y, swh, r.h, c_white, 0, 1.0 );
                    ICUI_text_color( c_white, c_white, c_white, c_white, "R", sx+swh+spacing, sy);
					sx+=swh+spacing+fontsize;
				} else if ( code == IC_A ) {
					ICUI_image( s_InputCandy_ICUI_icons, 12, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
				} else if ( code == IC_B ) {
					ICUI_image( s_InputCandy_ICUI_icons, 13, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
				} else if ( code == IC_X ) {
					ICUI_image( s_InputCandy_ICUI_icons, 10, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
				} else if ( code == IC_Y ) {
					ICUI_image( s_InputCandy_ICUI_icons, 11, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
				} else if ( code == IC_back_select ) {
					ICUI_image( s_InputCandy_ICUI_icons, 53, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
				} else if ( code == IC_start ) {
					ICUI_image( s_InputCandy_ICUI_icons, 54, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
				} else if ( code >= IC_btn0 and code <= IC_btn39 ) {
					ICUI_image( s_InputCandy_ICUI_icons, 9, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					sx+=swh+spacing;					
                    ICUI_text_color( c_white, c_white, c_white, c_white, int(code-IC_btn0), sx+swh+spacing+fontsize, sy);
					sx+=swh+spacing+fontsize*2;
				}
			break;
			case ICDeviceType_keyboard_mouse:
			case ICDeviceType_mouse:
			case ICDeviceType_keyboard:
				if ( is_directional ) {
				} else {
					switch ( code ) {
						case IC_mouse_left:
							ICUI_image( s_InputCandy_ICUI_icons, 24, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						break;
						case IC_mouse_right:
							ICUI_image( s_InputCandy_ICUI_icons, 26, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						break;
						case IC_mouse_middle:
							ICUI_image( s_InputCandy_ICUI_icons, 25, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						break;
						case IC_mouse_scrollup:
							ICUI_image( s_InputCandy_ICUI_icons, 27, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						break;
						case IC_mouse_scrolldown:
							ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						break;
					}
					sx+=swh+spacing;
				}
				if ( is_directional ) {
					if ( code == IC_wasd ) {
						ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"W",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"A",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"S",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"D",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						sx+=swh+spacing;
					} else if ( code == IC_arrows ) {
						ICUI_image( s_InputCandy_ICUI_icons, 49, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 48, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 51, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 52, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
					} else if ( code == IC_numpad ) { 
						ICUI_image( s_InputCandy_ICUI_icons, 75, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"8",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 76, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"2",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 77, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"4",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 78, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,"6",1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						sx+=swh+spacing;
					}
				} else if ( code >= IC_key_A and code <= IC_key_9 ) {
					ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					switch ( __INPUTCANDY.keyboard_layout ) {
						case ICKeyboardLayout_qwerty:
							draw_text_transformed_color(sx+swh/2,sy+swh/2,string_replace(__INPUTCANDY.signals[code].name,"Key ",""), 1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						break;
						case ICKeyboardLayout_azerty:
							draw_text_transformed_color(sx+swh/2,sy+swh/2,string_replace(__INPUTCANDY.signals[code].azerty_name,"Key ",""), 1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						break;
						case ICKeyboardLayout_qwertz:
							draw_text_transformed_color(sx+swh/2,sy+swh/2,string_replace(__INPUTCANDY.signals[code].qwertz_name,"Key ",""), 1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						break;
					}
					sx+=swh+spacing;
				} else if ( code >= IC_backspace and code <= IC_f12 ) {
					switch ( code ) {
						case IC_backspace:     
							ICUI_image( s_InputCandy_ICUI_icons, 31, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_any_alt:		
							ICUI_image( s_InputCandy_ICUI_icons, 39, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_any_shift:		
							ICUI_image( s_InputCandy_ICUI_icons, 33, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_any_control:	
							ICUI_image( s_InputCandy_ICUI_icons, 36, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_lalt:			
							ICUI_image( s_InputCandy_ICUI_icons, 41, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_ralt:			
							ICUI_image( s_InputCandy_ICUI_icons, 40, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_lctrl:			
							ICUI_image( s_InputCandy_ICUI_icons, 37, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_rctrl:			
							ICUI_image( s_InputCandy_ICUI_icons, 38, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_lshift:		
							ICUI_image( s_InputCandy_ICUI_icons, 34, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_rshift:		
							ICUI_image( s_InputCandy_ICUI_icons, 35, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_tab:			
							ICUI_image( s_InputCandy_ICUI_icons, 43, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_pause:			
							ICUI_image( s_InputCandy_ICUI_icons, 55, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_print:			
							ICUI_image( s_InputCandy_ICUI_icons, 56, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_pgup:			
							ICUI_image( s_InputCandy_ICUI_icons, 57, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_pgdn:			
							ICUI_image( s_InputCandy_ICUI_icons, 58, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_home:			
							ICUI_image( s_InputCandy_ICUI_icons, 59, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_end:			
							ICUI_image( s_InputCandy_ICUI_icons, 63, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_insert:		
							ICUI_image( s_InputCandy_ICUI_icons, 61, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_delete:		
							ICUI_image( s_InputCandy_ICUI_icons, 60, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad0:		
							ICUI_image( s_InputCandy_ICUI_icons, 85, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad1:		
							ICUI_image( s_InputCandy_ICUI_icons, 83, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad2:		
							ICUI_image( s_InputCandy_ICUI_icons, 79, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad3:		
							ICUI_image( s_InputCandy_ICUI_icons, 82, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad4:		
							ICUI_image( s_InputCandy_ICUI_icons, 76, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad5:		
							ICUI_image( s_InputCandy_ICUI_icons, 79, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad6:		
							ICUI_image( s_InputCandy_ICUI_icons, 77, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad7:		
							ICUI_image( s_InputCandy_ICUI_icons, 81, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad8:		
							ICUI_image( s_InputCandy_ICUI_icons, 75, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad9:		
							ICUI_image( s_InputCandy_ICUI_icons, 81, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad_multiply:
							ICUI_image( s_InputCandy_ICUI_icons, 89, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad_divide:  
							ICUI_image( s_InputCandy_ICUI_icons, 88, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad_subtract:
							ICUI_image( s_InputCandy_ICUI_icons, 87, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_numpad_decimal: 
							ICUI_image( s_InputCandy_ICUI_icons, 84, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f1:		     
							ICUI_image( s_InputCandy_ICUI_icons, 63, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f2:		     
							ICUI_image( s_InputCandy_ICUI_icons, 64, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f3:		     
							ICUI_image( s_InputCandy_ICUI_icons, 65, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f4:		     
							ICUI_image( s_InputCandy_ICUI_icons, 66, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f5:		     
							ICUI_image( s_InputCandy_ICUI_icons, 67, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f6:		     
							ICUI_image( s_InputCandy_ICUI_icons, 68, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f7:		     
							ICUI_image( s_InputCandy_ICUI_icons, 69, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f8:		     
							ICUI_image( s_InputCandy_ICUI_icons, 70, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f9:		     
							ICUI_image( s_InputCandy_ICUI_icons, 71, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f10:		     
							ICUI_image( s_InputCandy_ICUI_icons, 72, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f11:		     
							ICUI_image( s_InputCandy_ICUI_icons, 73, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_f12:
							ICUI_image( s_InputCandy_ICUI_icons, 74, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
					}
				} else if ( code >= IC_key_backtick and code <= IC_key_apostrophe ) {
						ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+swh/2,sy+swh/2,__INPUTCANDY.signals[code].keychar,1.0/fontsize*swh*0.8,1.0/fontsize*swh*0.8,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
				} else if ( code >= IC_enter and code <= IC_key_escape ) {
					switch ( code ) {
						case IC_enter:
							ICUI_image( s_InputCandy_ICUI_icons, 45, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_space:
							ICUI_image( s_InputCandy_ICUI_icons, 91, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
						case IC_key_escape:
							ICUI_image( s_InputCandy_ICUI_icons, 46, sx, r.y, swh, r.h, c_white, 0, 1.0 );
							sx+=swh+spacing;
						break;
					}
				}
			break;
		}
		if ( i+1 != len ) {
			ICUI_text( false, (is_combo or key_mouse_combo) ? "and" : "or", sx + ( spacing*2 + fontsize*5 ) /2, sy + swh/2 );
			sx += spacing+fontsize*5+spacing;
		}
	}	
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
		var player=__INPUTCANDY.players[player_index];
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
				 __INPUTCANDY.ui.input_binding.influencing=-1;
				 __INPUTCANDY.ui.input_binding.scrolled=0;
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
				 __INPUTCANDY.ui.gamepad_test.mode=true;
				break;
				case 5:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.input_binding.mode=true;
				 __INPUTCANDY.ui.input_binding.influencing=-1;
				 __INPUTCANDY.ui.input_binding.scrolled=0;
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
			 audio_play_sound(a_ICUI_pageflip,100,0);
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
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_input_binding() {

    // Create new settings if none exist, otherwise let the player choose existing settings or create new.
	if ( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings == none ) {
		if ( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device == none ) {
			if ( __INPUTCANDY.ui.device_select.influencing != 0 or !__INPUTCANDY.ui.input_binding.keyboard_mouse ) { // Return to previous screen
				__INPUTCANDY.ui.device_select.mode=true;
				__INPUTCANDY.ui.input_binding.mode=false;
				return;
			} else if (array_length(__INPUTCANDY.settings) == 0 and __INPUTCANDY.ui.input_binding.keyboard_mouse) {
			__INPUTCANDY.settings[0]=__ICI.New_ICSettings();
			__INPUTCANDY.settings[0].deviceInfo=__ICI.New_ICDevice();
			__INPUTCANDY.settings[0].deviceInfo.desc="Keyboard and Mouse";
			__INPUTCANDY.settings[0].deviceInfo.type=ICDeviceType_keyboard_mouse;
			__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings = 0;				
			}
		} else if ( array_length(__INPUTCANDY.settings) == 0 ) {
			__INPUTCANDY.settings[0]=__ICI.New_ICSettings();
			__INPUTCANDY.settings[0].deviceInfo=__INPUTCANDY.devices[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device];
			__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings = 0;
			__INPUTCANDY.settings[0].deadzone1=gamepad_get_axis_deadzone(__INPUTCANDY.settings[0].deviceInfo.slot_id);
			__INPUTCANDY.settings[0].deadzone2=gamepad_get_button_threshold(__INPUTCANDY.settings[0].deviceInfo.slot_id);
		} else __INPUTCANDY.ui.input_binding.loading=true;
	}
	
	if ( __INPUTCANDY.ui.input_binding.loading ) {
		ICUI_Draw_input_binding_set_profile();
		return;
	}
	
	
    if ( __INPUTCANDY.ui.input_binding.choosing ) {
		ICUI_Draw_input_binding_choice();
		return;
	}

    if ( __INPUTCANDY.ui.input_binding.choosing_pick ) {
		ICUI_Draw_input_binding_choice_pick();
		return;
	}
	 

    if ( __INPUTCANDY.ui.input_binding.choosing_capture ) {
		ICUI_Draw_input_binding_choice_capture();
		return;
	}

    var action_count=array_length(__INPUTCANDY.actions);
	var bindable_action_index=[];
	var bindable_actions=0;
	for ( var i=0; i<action_count; i++ ) {
		if ( __INPUTCANDY.actions[i].forbid_rebinding ) continue;
		bindable_action_index[array_length(bindable_action_index)]=i;
		bindable_actions++;
	}
	
    var max_menuitem=bindable_actions+6;  // 0 Back button, 1 New Settings Profile, 2 Choose Settings Profile, 3/4 Up/Down Scroll, Deadzone1, Deadzone2
	var mi_back=max_menuitem-6;  // Back
	var mi_new=max_menuitem-5;   // New Profile
	var mi_load=max_menuitem-4;  // Choose profile
	var mi_dz1=max_menuitem-3;   // Deadzone 1
	var mi_dz2=max_menuitem-2;     // Deadzone 2
	var mi_scrup=max_menuitem-1; // Up
	var mi_scrdn=max_menuitem; // Down
	if ( __INPUTCANDY.ui.input_binding.influencing < 0 ) {
		__INPUTCANDY.ui.input_binding.influencing=mi_back;
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
		
	// Draws a background
	ICUI_text_in_box( false, "", __INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, __INPUTCANDY.ui.region.w, __INPUTCANDY.ui.region.h );

	var sx=__INPUTCANDY.ui.region.x;
	var sy=__INPUTCANDY.ui.region.y;

	// Back Button
	var r=rectangle(__INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, eh*2, eh*2);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.influencing=max_menuitem;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Input Settings #"+int(__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings+1), ox+__INPUTCANDY.ui.region.w/2, oy );
	ICUI_text( false, "(Created for "+__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.desc+")", ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	oy+=smidge+eh*2;

      var buttons_region=rectangle( __INPUTCANDY.ui.region.x+eh, oy-eh, __INPUTCANDY.ui.region.w-(eh*5), eh );
	  
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_new, "New Profile", buttons_region.x, buttons_region.y, buttons_region.w/2-smidge, buttons_region.h );
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_load, "Choose Profile", buttons_region.x + buttons_region.w/2, buttons_region.y, buttons_region.w/2, buttons_region.h );  
	  
	  var lines_region=rectangle(__INPUTCANDY.ui.region.x+eh,oy+smidge,__INPUTCANDY.ui.region.w-(eh*5),__INPUTCANDY.ui.region.y2-oy-eh*3);
	  var lineh=eh*2;
	  var lineskip=smidge;
	  var lines=floor(lines_region.h / (lineh+lineskip));
	  var sb_region=rectangle(lines_region.x2+eh/2,lines_region.y,eh*2,lines_region.h);
	  var sb_up=rectangle(sb_region.x,sb_region.y,sb_region.w,sb_region.w);
	  var sb_dn=rectangle(sb_region.x,sb_region.y+sb_region.h-sb_up.h,sb_up.w,sb_up.h);
	  var sb_mid=rectangle(sb_up.x,sb_up.y2,sb_region.w,sb_region.h-sb_up.h*2);
	  var dz1=rectangle(lines_region.x,sb_dn.y2,lines_region.w/2-eh/2,eh*2);
	  var dz2=rectangle(dz1.x+lines_region.w/2+eh/2,dz1.y,dz1.w,dz1.h);

	var start_item=__INPUTCANDY.ui.input_binding.scrolled;
	var end_item=min(bindable_actions-1,start_item+lines-1);

	if ( bindable_actions > 0 ) {
	    ox=lines_region.x;
		oy=lines_region.y;
		for ( var i=start_item; (i<bindable_actions) and (i-start_item<lines); i++ ) {
			var action=__INPUTCANDY.actions[bindable_action_index[i]];
			var bound=__ICI.GetBindingData( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings, bindable_action_index[i] );
			ICUI_text_in_box( false, string_replace(action.group+" ","None ","")+action.name, ox,oy, lines_region.w/2-smidge/2, lineh );
			ICUI_text_in_box( __INPUTCANDY.ui.input_binding.influencing == i, "", ox + lines_region.w/2 - smidge/4, oy, lines_region.w/2, lineh );
			if ( bound != none ) {
				if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse )
				ICUI_draw_ICaction( bound.bound_action.gamepad, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
				 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
				);
				else
				ICUI_draw_ICaction( bound.bound_action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, action.mouse_keyboard_combo, 
				 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
				);
			} else {
				if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse )
				ICUI_draw_ICaction( action.gamepad, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
				 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
				);
				else
				ICUI_draw_ICaction( action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, action.mouse_keyboard_combo, 
				 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
				);
			}
			oy+=lineh+lineskip;
		}
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_scrdn, "", sb_dn.x,sb_dn.y,sb_dn.w,sb_dn.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 3, sb_dn.x, sb_dn.y, sb_dn.w, sb_dn.h, c_white, 0.65, 0, 0.5 );
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_scrup, "", sb_up.x,sb_up.y,sb_up.w,sb_up.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 2, sb_up.x, sb_up.y, sb_up.w, sb_up.h, c_white, 0.65, 0, 0.5 );
		ICUI_box(sb_mid.x,sb_mid.y,sb_mid.w,sb_mid.h);
		var first_perc=(__INPUTCANDY.ui.input_binding.scrolled / bindable_actions);
		var last_perc=min(1.0,(__INPUTCANDY.ui.input_binding.scrolled+lines) / bindable_actions);
		var total_size=sb_mid.h-smidge*2;
		ICUI_tinted_box(__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2, sb_mid.x+smidge, sb_mid.y+smidge + total_size*first_perc, sb_mid.w-smidge*2, (total_size*last_perc)-(total_size*first_perc) );
	}

	if ( __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1 != none ) {
		ICUI_surround_button( __INPUTCANDY.ui.input_binding.influencing == mi_dz1, dz1.x, dz1.y, dz1.w, dz1.h );
	}
	if ( __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2 != none ) {
		ICUI_surround_button( __INPUTCANDY.ui.input_binding.influencing == mi_dz2, dz2.x, dz2.y, dz2.w, dz2.h );
	}

	if ( __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1 != none ) {
		ICUI_text( false, 
			"Axis DeadZone: "+string_format(__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1,1,2),
			dz1.x+dz1.w/4, dz1.y+dz1.h/2 );
		ICUI_slider( __INPUTCANDY.ui.input_binding.influencing == mi_dz1, 
			__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1,
			0.05, dz1.x+dz1.w/2,dz1.y,dz1.w/2,dz1.h );
	}
	if ( __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2 != none ) {
		ICUI_text( false,
			"Btn Threshold: "+string_format(__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2,1,2),
			dz2.x+dz2.w/4, dz2.y+dz2.h/2 );
		ICUI_slider( __INPUTCANDY.ui.input_binding.influencing == mi_dz2, 
			__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2,
			0.05, dz2.x+dz2.w/2,dz2.y,dz2.w/2,dz2.h );
	}
	
	
	
	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.influencing++;
		if ( __INPUTCANDY.ui.input_binding.influencing == end_item+1 and end_item < bindable_actions ) __INPUTCANDY.ui.input_binding.influencing=mi_scrdn;
		if ( __INPUTCANDY.ui.input_binding.influencing > max_menuitem ) {
			__INPUTCANDY.ui.input_binding.influencing=__INPUTCANDY.ui.input_binding.scrolled;
		}
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.influencing--;
		if ( __INPUTCANDY.ui.input_binding.influencing < 0 ) __INPUTCANDY.ui.input_binding.influencing=max_menuitem;
		if ( __INPUTCANDY.ui.input_binding.scrolled > 0 and __INPUTCANDY.ui.input_binding.influencing == __INPUTCANDY.ui.input_binding.scrolled-1 ) __INPUTCANDY.ui.input_binding.influencing=mi_scrup;
		if ( __INPUTCANDY.ui.input_binding.influencing == mi_back-1 ) __INPUTCANDY.ui.input_binding.influencing=end_item;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.input_binding.influencing ) {
			case mi_back: // Abort / go back / cancel
		 	 __INPUTCANDY.ui.input_binding.mode=false;
			 __INPUTCANDY.ui.device_select.mode=true;
			 audio_play_sound(a_ICUI_pageflip,100,0);
			break;
			case mi_new: // New Profile mode
				audio_play_sound(a_ICUI_tone,100,0);
			break;
			case mi_load: // Choose Profile mode
				audio_play_sound(a_ICUI_tone,100,0);
			break;
			case mi_scrup: // Scroll up
			 if ( __INPUTCANDY.ui.input_binding.scrolled > 0 ) __INPUTCANDY.ui.input_binding.scrolled--;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_scrdn: // Scroll down
			 if ( __INPUTCANDY.ui.input_binding.scrolled < bindable_actions - (lines - 1) ) __INPUTCANDY.ui.input_binding.scrolled++;
			 if ( __INPUTCANDY.ui.input_binding.scrolled < 0 ) __INPUTCANDY.ui.input_binding.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_dz1: // Set axis deadzone
			 __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1+=0.05;
			 if (__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1>1.0)
				 __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1=0.05;  /// Setting below this may have undesirable consequences
             audio_play_sound(a_ICUI_tone,100,0);
			break;
			case mi_dz2: // Set button deadzone
			 __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2+=0.05;
			 if (__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2>1.0)
				 __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2=0.05;  /// Setting below this may have undesirable consequences
             audio_play_sound(a_ICUI_tone,100,0);
			break;
			default:
				__INPUTCANDY.ui.input_binding.choosing=true;
				__INPUTCANDY.ui.input_binding.choosing_select=0;
				__INPUTCANDY.ui.input_binding.choosing_capture=false;
				__INPUTCANDY.ui.input_binding.choosing_pick=false;
				audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	}		

	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}


function ICUI_Draw_input_binding_choice() {
	
	var region=__INPUTCANDY.ui.region;
	ICUI_text_in_box( false, "", region.x, region.y, region.w, region.h );
	
	var ox=region.x;
	var oy=region.y;
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
	
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var settings_index=__INPUTCANDY.players[player_index].settings;
	var player=__INPUTCANDY.players[player_index];
	var device=player.device == none ? none : __INPUTCANDY.devices[player.device];
    var action_count=array_length(__INPUTCANDY.actions);
	var bindable_action_index=[];
	var bindable_actions=0;
	for ( var i=0; i<action_count; i++ ) {
		if ( __INPUTCANDY.actions[i].forbid_rebinding ) continue;
		bindable_action_index[array_length(bindable_action_index)]=i;
		bindable_actions++;
	}	
	var action_index=bindable_action_index[__INPUTCANDY.ui.input_binding.influencing];
	var action=__INPUTCANDY.actions[action_index];
	
	oy+=eh;
	ICUI_text( false,
		"Player #"+int(player_index+1)+" Input Settings #"+int(settings_index+1),
		ox+__INPUTCANDY.ui.region.w/2, oy
	);
	oy+=smidge+eh*2;
	ICUI_text( false,
		"Set Binding for "+string_replace(action.group+" ","None ","")+action.name,
		ox+__INPUTCANDY.ui.region.w/2, oy
	);
	oy+=smidge+eh*2;
	
	var bound=__ICI.GetBindingData(settings_index,action_index);
	if ( bound != none ) {
		ICUI_text( false, "Current Binding:", ox+__INPUTCANDY.ui.region.w/4, oy	);
		oy+=smidge;
		if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse )
		ICUI_draw_ICaction( bound.bound_action.gamepad, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
		 rectangle( ox + __INPUTCANDY.ui.region.w/4, oy, __INPUTCANDY.ui.region.w/2, eh*2 )
		);
		else
		ICUI_draw_ICaction( bound.bound_action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, action.mouse_keyboard_combo, 
		 rectangle( ox + __INPUTCANDY.ui.region.w/4, oy, __INPUTCANDY.ui.region.w/2,  eh*2 )
		);
		oy-=smidge;
	} else {
		ICUI_text( false, "No Custom Binding", ox+__INPUTCANDY.ui.region.w/4, oy	);
	}
	
	ICUI_text( false, "Default:", ox+__INPUTCANDY.ui.region.w/4+__INPUTCANDY.ui.region.w/2, oy );	
	oy+=smidge;
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse )
	ICUI_draw_ICaction( action.gamepad, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
	 rectangle( ox + __INPUTCANDY.ui.region.w/4+__INPUTCANDY.ui.region.w/2, oy, __INPUTCANDY.ui.region.w/2,  eh*2 )
	);
	else
	ICUI_draw_ICaction( action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, action.mouse_keyboard_combo, 
	 rectangle( ox + __INPUTCANDY.ui.region.w/4+__INPUTCANDY.ui.region.w/2, oy, __INPUTCANDY.ui.region.w/2,  eh*2 )
	);
	oy+=smidge+eh*2;
	
	var sx=region.x;
	var sy=region.y;	
	
	var menu_margin=0.1*region.w;
	var btn_width=region.w-menu_margin*2;
	var btn_height=region.h/12;
	
	var max_menuitem=3;
	var mi_back=0;
	var mi_select_from_list=1;
	var mi_capture_input=2;
	var mi_set_to_default=3;

	// Back button
	r=rectangle(region.x, region.y, eh*2, eh*2);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,region.x+eh,region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);
	sy+=btn_height;

	sx = menu_margin+region.x;
	var max_menuitem=4;
	sy += 5*btn_height+btn_height/5;
	r =rectangle( sx, sy, btn_width, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_select_from_list;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_select == mi_select_from_list, "Select From List", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	r =rectangle( sx, sy, btn_width, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_capture_input;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_select == mi_capture_input, "Capture Input", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	r =rectangle( sx, sy, btn_width, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_set_to_default;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_select == mi_set_to_default, "Set to Default", r.x,r.y,r.w,r.h );

	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.choosing_select++;
		if ( __INPUTCANDY.ui.input_binding.choosing_select > max_menuitem ) __INPUTCANDY.ui.device_select.menuitem=0;
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.choosing_select--;
		if ( __INPUTCANDY.ui.input_binding.choosing_select < 0 ) __INPUTCANDY.ui.input_binding.choosing_select=max_menuitem;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.input_binding.choosing_select ) {
			case mi_back: // Back
				audio_play_sound(a_ICUI_pageflip,100,0);
		 		__INPUTCANDY.ui.input_binding.choosing=false;
			break;
			case mi_select_from_list:
				audio_play_sound(a_ICUI_pageflip,100,0);
		 		__INPUTCANDY.ui.input_binding.choosing=false;
				__INPUTCANDY.ui.input_binding.choosing_action=action_index;
				__INPUTCANDY.ui.input_binding.choosing_pick=true;
				__INPUTCANDY.ui.input_binding.choosing_pick_select=0;
				__INPUTCANDY.ui.input_binding.choosing_pick_scrolled=0;
			break;
			case mi_capture_input:
				audio_play_sound(a_ICUI_pageflip,100,0);
		 		__INPUTCANDY.ui.input_binding.choosing=false;
				__INPUTCANDY.ui.input_binding.choosing_action=action_index;
				__INPUTCANDY.ui.input_binding.choosing_capture=false;
				__INPUTCANDY.ui.input_binding.choosing_capture_expired=0.0;
				__INPUTCANDY.ui.input_binding.choosing_capture_2=false;
				__INPUTCANDY.ui.input_binding.choosing_capture_confirming=false;
				__INPUTCANDY.ui.input_binding.choosing_capture_select=0;				
			break;
			case mi_set_to_default:
				audio_play_sound(a_ICUI_tone,100,0);
				var b_index=__ICI.GetBinding( settings_index, action_index );
				if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse )
					__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.keyboard=action.keyboard;
				else
					__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.gamepad=action.gamepad;
	 			__INPUTCANDY.ui.input_binding.choosing=false;
			break;
		}
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
	
}


function ICUI_Draw_input_binding_choice_pick() {
	
	var action_index=__INPUTCANDY.ui.input_binding.choosing_action;
	var action=__INPUTCANDY.actions[action_index];
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var settings_index=__INPUTCANDY.players[player_index].settings;
	var player=__INPUTCANDY.players[player_index];
	var device=player.device == none ? none : __INPUTCANDY.devices[player.device];

	var bound=__ICI.GetBindingData(settings_index,action_index);
	
	// Build the binding options
	
	var bindables=[];
	var target_deviceType=ICDeviceType_gamepad;
	var target_is_combo = action.gamepad_combo;
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
		target_deviceType=ICDeviceType_keyboard_mouse;
		target_is_combo = action.keyboard_combo;
		if ( action.is_directional ) {
			bindables[array_length(bindables)]={ type: ICDeviceType_keyboard, code: IC_wasd, name: "WASD" };
			bindables[array_length(bindables)]={ type: ICDeviceType_keyboard, code: IC_arrows, name: "Arrow Keys" };
			bindables[array_length(bindables)]={ type: ICDeviceType_keyboard, code: IC_numpad, name: "Numpad Arrows" };
			/* (add mouse move here if you wanted to) */
		} else {
			for ( var i=__FIRST_MOUSE_SIGNAL; i<__LAST_KEYBOARD_SIGNAL_PLUS_1; i++ ) {
				bindables[array_length(bindables)]={ type: ICDeviceType_keyboard, code: __INPUTCANDY.signals[i].code, name: __INPUTCANDY.signals[i].name };
			}
		}
	} else { // Gamepad
		target_deviceType=ICDeviceType_gamepad;
		target_is_combo = action.gamepad_combo;
		if ( action.is_directional ) {
			bindables[array_length(bindables)]={ code: IC_dpad, name:"D-Pad" };
			if ( device != none ) {
				if ( device.hat_count > 0 ) bindables[array_length(bindables)]={ code: IC_hat0, name: "Hat0" };
				for ( var j=1; j<device.hat_count; j++ ) bindables[array_length(bindables)]={ code: IC_hat0+j, name: "Hat"+int(j) };
				if ( device.axis_count > 0 ) bindables[array_length(bindables)]={ code: IC_axis0, name: "Axis0" };
				for ( var j=2; j<device.axis_count; j+=2 ) if ( j+1 < device.axis_count ) bindables[array_length(bindables)]={ code: IC_axis0+j, name: "Axis"+int(j)+"&"+int(j+1) };
			}
		} else {
			for ( var i=__FIRST_GAMEPAD_SIGNAL; i<__LAST_GAMEPAD_SIGNAL_PLUS_1; i++ ) {
				if ( __INPUTCANDY.signals[i].code == IC_AandB ) continue;
				if ( __INPUTCANDY.signals[i].code == IC_XandY ) continue;
				bindables[array_length(bindables)]={ type: ICDeviceType_gamepad, code: __INPUTCANDY.signals[i].code, name: __INPUTCANDY.signals[i].name };
			}
			var last_signal_plus_1 = array_length(__INPUTCANDY.signals );
			for ( var i=__LAST_KEYBOARD_SIGNAL_PLUS_1; i<last_signal_plus_1; i++ ) {
				if ( __INPUTCANDY.signals[i].deviceType == ICDeviceType_gamepad ) 
					bindables[array_length(bindables)]={ type: ICDeviceType_gamepad, code: __INPUTCANDY.signals[i].code, name: __INPUTCANDY.signals[i].name };
			}
		}		
	}
	
	var bindables_count = array_length(bindables);
	
    var max_menuitem=bindables_count+2;  // 0 Back button, 1/2 Up/Down Scroll
	var mi_back=max_menuitem-2;  // Back / Cancel
	var mi_scrup=max_menuitem-1; // Up
	var mi_scrdn=max_menuitem; // Down
	
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
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_pick_select=max_menuitem;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_pick_select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Input Settings #"+int(__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings+1), ox+__INPUTCANDY.ui.region.w/2, oy );
	ICUI_text( false, "(Created for "+__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.desc+")",
		ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	ICUI_text( false, "For Action: "+string_replace(action.group+" "+action.name,"None ",""), ox+__INPUTCANDY.ui.region.w/2, oy+eh*2 );
	oy+=smidge+eh*3;

      var buttons_region=rectangle( __INPUTCANDY.ui.region.x+eh, oy-eh, __INPUTCANDY.ui.region.w-(eh*5), eh );
	  
	  var lines_region=rectangle(__INPUTCANDY.ui.region.x+eh,oy+smidge,__INPUTCANDY.ui.region.w-(eh*5),__INPUTCANDY.ui.region.y2-oy-eh*3);
	  var lineh=eh*2;
	  var lineskip=smidge;
	  var lines=floor(lines_region.h / (lineh+lineskip));
	  var sb_region=rectangle(lines_region.x2+eh/2,lines_region.y,eh*2,lines_region.h);
	  var sb_up=rectangle(sb_region.x,sb_region.y,sb_region.w,sb_region.w);
	  var sb_dn=rectangle(sb_region.x,sb_region.y+sb_region.h-sb_up.h,sb_up.w,sb_up.h);
	  var sb_mid=rectangle(sb_up.x,sb_up.y2,sb_region.w,sb_region.h-sb_up.h*2);
	  var dz1=rectangle(lines_region.x,sb_dn.y2,lines_region.w/2-eh/2,eh*2);
	  var dz2=rectangle(dz1.x+lines_region.w/2+eh/2,dz1.y,dz1.w,dz1.h);

	var start_item=__INPUTCANDY.ui.input_binding.choosing_pick_scrolled;
	var end_item=min(bindables_count-1,start_item+lines-1);

	if ( bindables_count > 0 ) {
	    ox=lines_region.x;
		oy=lines_region.y;
		for ( var i=start_item; (i<bindables_count) and (i-start_item<lines); i++ ) {
			var is_focused=__INPUTCANDY.ui.input_binding.choosing_pick_select == i;
			ICUI_text_in_box( false, bindables[i].name, ox,oy, lines_region.w/2-smidge/2, lineh );
			ICUI_text_in_box( is_focused, "", ox + lines_region.w/2 - smidge/4, oy, lines_region.w/2, lineh );
			ICUI_draw_ICaction( bindables[i].code, target_deviceType, action.is_directional, target_is_combo, action.mouse_keyboard_combo, 
			 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
			);
			oy+=lineh+lineskip;
			if ( is_focused ) {
				var conflicting=__ICI.GetActionsBindingsByCode( settings_index, bindables[i].code, bound == none ? none : bound.index, action_index );
				if ( conflicting.bindings_count > 0 or conflicting.actions_count > 0 ) {
					ICUI_text( false, "Choosing "+bindables[i].name+" when already in use by", lines_region.x+lines_region.w/2, lines_region.y2+eh );
					var results="";
					for ( var k=0; k<conflicting.bindings_count; k++ ) {
						results+=conflicting.bindings[k]+((k>0 and kconflicting.bindings_count-1)?",":"");
					}
					if ( string_length(results) > 0 and conflicting.actions_count > 0 ) {
						results+=" and ";
					}
					for ( var k=0; k<conflicting.actions_count; k++ ) {
						results+=string_replace(conflicting.actions[k].group+" "+conflicting.actions[k].name,"None ","")
						        +((k>0 and kconflicting.bindings_count-1)?",":"");
					}
					ICUI_text( false, results, lines_region.x+lines_region.w/2, lines_region.y2+eh*2 );
				}
			}
		}
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_pick_select == mi_scrdn, "", sb_dn.x,sb_dn.y,sb_dn.w,sb_dn.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 3, sb_dn.x, sb_dn.y, sb_dn.w, sb_dn.h, c_white, 0.65, 0, 0.5 );
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_pick_select == mi_scrup, "", sb_up.x,sb_up.y,sb_up.w,sb_up.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 2, sb_up.x, sb_up.y, sb_up.w, sb_up.h, c_white, 0.65, 0, 0.5 );
		ICUI_box(sb_mid.x,sb_mid.y,sb_mid.w,sb_mid.h);
		var first_perc=(__INPUTCANDY.ui.input_binding.choosing_pick_scrolled / bindables_count);
		var last_perc=min(1.0,(__INPUTCANDY.ui.input_binding.choosing_pick_scrolled+lines) / bindables_count);
		var total_size=sb_mid.h-smidge*2;
		ICUI_tinted_box(__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2, sb_mid.x+smidge, sb_mid.y+smidge + total_size*first_perc, sb_mid.w-smidge*2, (total_size*last_perc)-(total_size*first_perc) );
	}
	
	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.choosing_pick_select++;
		if ( __INPUTCANDY.ui.input_binding.choosing_pick_select == end_item+1 and end_item < bindables_count ) __INPUTCANDY.ui.input_binding.choosing_pick_select=mi_scrdn;
		if ( __INPUTCANDY.ui.input_binding.choosing_pick_select > max_menuitem ) {
			__INPUTCANDY.ui.input_binding.choosing_pick_select=__INPUTCANDY.ui.input_binding.choosing_pick_scrolled;
		}
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.choosing_pick_select--;
		if ( __INPUTCANDY.ui.input_binding.choosing_pick_select < 0 ) __INPUTCANDY.ui.input_binding.choosing_pick_select=max_menuitem;
		if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled > 0 and __INPUTCANDY.ui.input_binding.choosing_pick_select == __INPUTCANDY.ui.input_binding.choosing_pick_scrolled-1 ) __INPUTCANDY.ui.input_binding.choosing_pick_select=mi_scrup;
		if ( __INPUTCANDY.ui.input_binding.choosing_pick_select == mi_back-1 ) __INPUTCANDY.ui.input_binding.choosing_pick_select=end_item;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.input_binding.choosing_pick_select ) {
			case mi_back: // Abort / go back / cancel
		 	 __INPUTCANDY.ui.input_binding.choosing=true;
			 __INPUTCANDY.ui.input_binding.choosing_pick=false;
			 audio_play_sound(a_ICUI_pageflip,100,0);
			break;
			case mi_scrup: // Scroll up
			 if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled > 0 ) __INPUTCANDY.ui.input_binding.choosing_pick_scrolled--;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_scrdn: // Scroll down
			 if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled < bindables_count - (lines - 1) ) __INPUTCANDY.ui.input_binding.choosing_pick_scrolled++;
			 if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled < 0 ) __INPUTCANDY.ui.input_binding.choosing_pick_scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			default:
				if ( __INPUTCANDY.ui.input_binding.choosing_pick_select >= 0 and __INPUTCANDY.ui.input_binding.choosing_pick_select < bindables_count ) {
					var b=bindables[__INPUTCANDY.ui.input_binding.choosing_pick_select];
					if ( bound == none ) {
						bound = __INPUTCANDY.settings[settings_index].bindings[__ICI.AddBinding(settings_index,action.index)];
					}
					if ( b.type == ICDeviceType_mouse ) {
						__INPUTCANDY.settings[settings_index].bindings[bound.index].bound_action.mouse=b.code;
					} else if ( b.type == ICDeviceType_keyboard ) {
						__INPUTCANDY.settings[settings_index].bindings[bound.index].bound_action.keyboard=b.code;
					} else {
						__INPUTCANDY.settings[settings_index].bindings[bound.index].bound_action.gamepad=b.code;
					}
				}
				audio_play_sound(a_ICUI_tone,100,0);
			 	__INPUTCANDY.ui.input_binding.choosing=true;
				__INPUTCANDY.ui.input_binding.choosing_pick=false;
			break;
		}
	}		

	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}


function ICUI_Draw_input_binding_choice_capture() {
}


function ICUI_Draw_input_binding_set_profile() {
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
