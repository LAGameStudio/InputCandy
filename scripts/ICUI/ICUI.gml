/* 
   Script assets for the Controls Setup screens.  Style your way by modifying.
    - This is written to be modal (for the device_select, gamepad_setup and control_binding screens)
    - It is also written to be responsive, where you can set the region of the screen,
      generally it is a good idea to keep this relatively square, but it is possible to adapt the
	  values in real time to whatever floats your boat.
 */
 
 // UI mode options for ..ui.mode(...)

#macro ICUI_none -4
#macro ICUI_error -1
#macro ICUI_device_select 0
#macro ICUI_SDLDB_select 1
#macro ICUI_gamepad_test 2
#macro ICUI_input_binding 3

// UI signal options for ..ui.input(...)
#macro ICUI_up 0
#macro ICUI_down 1
#macro ICUI_left 2
#macro ICUI_right 3   
#macro ICUI_button 4   // any button pressed

// Tweakable time limits (seconds) used in Gamepad Test and Capture Input panels.
#macro ICUI_capture_duration_s 5
#macro ICUI_test_duration_s 8

function __Init_ICUI() {
	__INPUTCANDY.ui={
		exit_to: rm_InputCandy_testgame,
	    region: rectangle(128,128,room_width-256,room_height-256),   // Area of the screen for UI			
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
			  //////// Mouse support
			allow_mouse: false,        // When available, use the mouse.
			use_custom_cursor: true,   // Provide a mouse cursor.
			custom_mouse_cursor: s_InputCandy_ICUI_mouse_cursor,  // Use this one
			custom_mouse_cursor_tint: c_white   // Quickly change the look of the cursor
		},
		mode: function () { // Query the UI's current mode, or set its mode
			 if ( argument_count <1 ) {
			 if ( __INPUTCANDY.ui.device_select.mode ) return ICUI_device_select;
			 if ( __INPUTCANDY.ui.SDLDB_select.mode ) return ICUI_SDLDB_select;
			 if ( __INPUTCANDY.ui.gamepad_test.mode ) return ICUI_gamepad_test;
			 if ( __INPUTCANDY.ui.input_binding.mode ) return ICUI_input_binding;
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
				  __INPUTCANDY.ui.SDLDB_select.mode=true;
				  __INPUTCANDY.ui.SDLDB_select.search_mode=-1;
				 ICUI_DoSearch(__INPUTCANDY.devices[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device],none);
		         __INPUTCANDY.ui.SDLDB_select.scrolled=__INPUTCANDY.ui.device_select.influencing;
                 break;
				 case ICUI_gamepad_test:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.gamepad_test.mode=true;
				  __INPUTCANDY.ui.gamepad_test.expired=0.0;
				  __INPUTCANDY.ui.gamepad_test.exitting=false;
                 break;
				 case ICUI_input_binding:
				  __INPUTCANDY.ui.mode(ICUI_none);
				  __INPUTCANDY.ui.input_binding.mode=true;
				  __INPUTCANDY.ui.input_binding.capture={ // Special mode where we're capturing input.
				   exitting: false,          // Leaving capturing mode
		    	   expired: 0.0,             // How long we've been attempting to capture.
		    	   select: 0,                 // Menu on confirming page.
		    	   refresh_baseline: false,  // Turn this true to get a new baseline as we exit the capture frame.
		    	   baseline: none            // The baseline is a capture when we are beginning capture to detect changes.
		         };
                 break;			 
				 default: return false; break; // Couldn't set the mode.
			 }
             return true;
			}
		},
		expired: 0.0,  // seconds counter
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
			search_mode: -1,
			influencing: 0,
			scrolled: 0         // How many elements we've scrolled down the list.
		},
		// UI mode where we're testing a gamepad (leads to SDLDB_select and input_binding)
		gamepad_test: {
			mode: false,
			expired: 0.0,
			exitting: false
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
			choosing_capture_confirming: false,
            capture: { // Special mode where we're capturing input.
				exitting: false,          // Leaving capturing mode
		    	expired: 0.0,             // How long we've been attempting to capture.
		    	select: 0,                // Menu on confirming page
		    	refresh_baseline: false,  // Turn this true to get a new baseline as we exit the capture frame.
		    	baseline: none            // The baseline is a capture when we are beginning capture to detect changes.
		    },
			calibration_action: none,
			calibration: false,
			calibration_now: 0,
			loading: false,          // Set profile from list
			loading_select: 0,
			loading_scrolled: 0,
			confirm_exit: false,
			confirm_exit_message: ""
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


function ICUI_get_key_size( sx, sy, fontsize, swh ) {
	return rectangle(sx,sy,1.0/fontsize*swh*0.25,1.0/fontsize*swh*0.25);
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
					} else if ( code >= IC_stick_01 and code <= IC_stick_98 ) {
					  var directional_index=__ICI.GetDirectionalByCode( code );
					  if ( directional_index != none ) {
					   var str="Stick: "+int(__INPUTCANDY.directionals[directional_index].stickH)+"+"+int(__INPUTCANDY.directionals[directional_index].stickV);
					   ICUI_image( s_InputCandy_ICUI_icons, 17, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					   ICUI_text_color( c_white, c_white, c_white, c_white, str, sx+swh+spacing+fontsize, sy);
					   sx+=swh+spacing+fontsize*6;
					  }
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
						case 0: index=5; break;
						case 1: index=6; break;
						case 2: index=7; break;
						case 3: index=8; break;
						default: break;
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
					if ( code == IC_wasd ) {
						var key=ICUI_get_key_size(sx,r.y+r.h/2,fontsize,swh);
						ICUI_image( s_InputCandy_ICUI_icons, 29, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+r.h/2,key.y,"W",key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 29, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+r.h/2,key.y,"A",key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 29, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+r.h/2,key.y,"S",key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 29, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						draw_text_transformed_color(sx+r.h/2,key.y,"D",key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						sx+=swh+spacing;
					} else if ( code == IC_arrows ) {
						ICUI_image( s_InputCandy_ICUI_icons, 49, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 48, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 51, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 50, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
					} else if ( code == IC_numpad ) { 
						ICUI_image( s_InputCandy_ICUI_icons, 75, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 76, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 77, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
						ICUI_image( s_InputCandy_ICUI_icons, 78, sx, r.y, swh, r.h, c_white, 0, 1.0 );
						sx+=swh+spacing;
					} //else if ( code == IC_mouse_move ) { // could be added here
				} else if ( code >= IC_key_A and code <= IC_key_9 ) {
					ICUI_image( s_InputCandy_ICUI_icons, 29, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					var key=ICUI_get_key_size(sx,r.y+r.h/2,fontsize,swh);
					switch ( __INPUTCANDY.keyboard_layout ) {
						case ICKeyboardLayout_qwerty:
							draw_text_transformed_color(sx+swh/2,key.y,string_replace(__INPUTCANDY.signals[code].name,"Key ",""), key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						break;
						case ICKeyboardLayout_azerty:
							draw_text_transformed_color(sx+swh/2,key.y,string_replace(__INPUTCANDY.signals[code].azerty_name,"Key ",""), key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						break;
						case ICKeyboardLayout_qwertz:
							draw_text_transformed_color(sx+swh/2,key.y,string_replace(__INPUTCANDY.signals[code].qwertz_name,"Key ",""), key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);						
						break;
					}
					sx+=swh+spacing;
				} else if ( code >= IC_key_arrow_L and code <= IC_f12 ) {
					switch ( code ) {
						case IC_key_arrow_U:		ICUI_image( s_InputCandy_ICUI_icons, 49, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_key_arrow_D:		ICUI_image( s_InputCandy_ICUI_icons, 48, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_key_arrow_L:		ICUI_image( s_InputCandy_ICUI_icons, 51, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_key_arrow_R:		ICUI_image( s_InputCandy_ICUI_icons, 50, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_backspace:			ICUI_image( s_InputCandy_ICUI_icons, 30, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_any_alt:			ICUI_image( s_InputCandy_ICUI_icons, 39, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_any_shift:			ICUI_image( s_InputCandy_ICUI_icons, 33, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_any_control:		ICUI_image( s_InputCandy_ICUI_icons, 36, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_lalt:				ICUI_image( s_InputCandy_ICUI_icons, 41, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_ralt:				ICUI_image( s_InputCandy_ICUI_icons, 40, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_lctrl:				ICUI_image( s_InputCandy_ICUI_icons, 37, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_rctrl:				ICUI_image( s_InputCandy_ICUI_icons, 38, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_lshift:				ICUI_image( s_InputCandy_ICUI_icons, 34, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_rshift:				ICUI_image( s_InputCandy_ICUI_icons, 35, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_tab:				ICUI_image( s_InputCandy_ICUI_icons, 43, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_pause:				ICUI_image( s_InputCandy_ICUI_icons, 55, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_print:				ICUI_image( s_InputCandy_ICUI_icons, 56, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_pgup:				ICUI_image( s_InputCandy_ICUI_icons, 57, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_pgdn:				ICUI_image( s_InputCandy_ICUI_icons, 58, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_home:				ICUI_image( s_InputCandy_ICUI_icons, 59, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_end:				ICUI_image( s_InputCandy_ICUI_icons, 63, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_insert:				ICUI_image( s_InputCandy_ICUI_icons, 61, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_delete:				ICUI_image( s_InputCandy_ICUI_icons, 60, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad0:			ICUI_image( s_InputCandy_ICUI_icons, 85, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad1:			ICUI_image( s_InputCandy_ICUI_icons, 83, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad2:			ICUI_image( s_InputCandy_ICUI_icons, 78, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad3:			ICUI_image( s_InputCandy_ICUI_icons, 82, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad4:			ICUI_image( s_InputCandy_ICUI_icons, 76, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad5:			ICUI_image( s_InputCandy_ICUI_icons, 79, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad6:			ICUI_image( s_InputCandy_ICUI_icons, 77, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad7:			ICUI_image( s_InputCandy_ICUI_icons, 80, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad8:			ICUI_image( s_InputCandy_ICUI_icons, 75, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad9:			ICUI_image( s_InputCandy_ICUI_icons, 81, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad_multiply:	ICUI_image( s_InputCandy_ICUI_icons, 89, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad_divide:		ICUI_image( s_InputCandy_ICUI_icons, 88, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad_subtract:	ICUI_image( s_InputCandy_ICUI_icons, 87, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad_add:			ICUI_image( s_InputCandy_ICUI_icons, 86, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_numpad_decimal:		ICUI_image( s_InputCandy_ICUI_icons, 84, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f1:					ICUI_image( s_InputCandy_ICUI_icons, 63, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f2:					ICUI_image( s_InputCandy_ICUI_icons, 64, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f3:					ICUI_image( s_InputCandy_ICUI_icons, 65, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f4:					ICUI_image( s_InputCandy_ICUI_icons, 66, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f5:					ICUI_image( s_InputCandy_ICUI_icons, 67, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f6:					ICUI_image( s_InputCandy_ICUI_icons, 68, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f7:					ICUI_image( s_InputCandy_ICUI_icons, 69, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f8:					ICUI_image( s_InputCandy_ICUI_icons, 70, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f9:					ICUI_image( s_InputCandy_ICUI_icons, 71, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f10:				ICUI_image( s_InputCandy_ICUI_icons, 72, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f11:				ICUI_image( s_InputCandy_ICUI_icons, 73, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_f12:				ICUI_image( s_InputCandy_ICUI_icons, 74, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						default:
							{
								var key=ICUI_get_key_size(sx,r.y+r.h/2,fontsize,swh);
								draw_text_transformed_color(sx+swh/2,key.y,"?", key.w,key.h,0,c_white,c_dkgray,c_white,c_dkgray,1.0);						
							}
						break;
					}
					sx+=swh+spacing;					
				} else if ( code >= IC_key_backtick and code <= IC_key_apostrophe ) {
					var key=ICUI_get_key_size(sx,r.y+r.h/2,fontsize,swh);
					ICUI_image( s_InputCandy_ICUI_icons, 30, sx, r.y, swh, r.h, c_white, 0, 1.0 );
					draw_text_transformed_color(sx,key.y,__INPUTCANDY.signals[code].keychar,key.w,key.h,0,c_black,c_dkgray,c_black,c_dkgray,1.0);
					sx+=swh+spacing;
				} else if ( code >= IC_enter and code <= IC_key_escape ) {
					switch ( code ) {
						case IC_enter:				ICUI_image( s_InputCandy_ICUI_icons, 45, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_space:				ICUI_image( s_InputCandy_ICUI_icons, 90, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_key_escape:			ICUI_image( s_InputCandy_ICUI_icons, 46, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
					}
					sx+=swh+spacing;
				} else if ( code >= IC_mouse_left and code <= IC_mouse_scrollup ) {
					switch ( code ) {
						case IC_mouse_left:			ICUI_image( s_InputCandy_ICUI_icons, 24, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_mouse_right:		ICUI_image( s_InputCandy_ICUI_icons, 26, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_mouse_middle:		ICUI_image( s_InputCandy_ICUI_icons, 25, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_mouse_scrollup:		ICUI_image( s_InputCandy_ICUI_icons, 27, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
						case IC_mouse_scrolldown:	ICUI_image( s_InputCandy_ICUI_icons, 28, sx, r.y, swh, r.h, c_white, 0, 1.0 ); break;
					}
					sx+=swh+spacing;
				}
			break;
		}
		if ( i+1 != len ) {
			ICUI_text( false, (is_combo or key_mouse_combo) ? "and" : "or", sx + spacing, sy );
		//	sx += spacing;
			sx += ( (is_combo or key_mouse_combo) ? 3 : 2 ) * fontsize+spacing*2;
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
		case ICUI_device_select: ICUI_Draw_device_select(__INPUTCANDY.ui.exit_to);	break;
		case ICUI_gamepad_test: ICUI_Draw_gamepad_test(); break;
		case ICUI_SDLDB_select: ICUI_Draw_SDLDB_select(); break;
		case ICUI_input_binding: ICUI_Draw_input_binding(); break;
		default: return false;
	}
	return true;
}


function ICUI_Draw_device_select( exit_to ) {
	
	var device_count=array_length(__INPUTCANDY.devices);
	
	if ( __INPUTCANDY.max_players == 1 and device_count == 0 ) { // Skip gamepad selection, go right to Keyboard/Mouse Input Binding
		__INPUTCANDY.ui.device_select.mode=false;
		__INPUTCANDY.ui.input_binding.mode=true;
		__INPUTCANDY.ui.input_binding.keyboard_and_mouse=true;
		return;
	}
	
	if ( __INPUTCANDY.ui.device_select.swapping ) { // This section is only drawn once you have opted to switch gamepads (menu option in selecting)
		ICUI_Draw_device_select_swapping();
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
	
	oy+=eh;
	ICUI_text( false, "Choose Device and Configure Controls", ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=smidge+eh*2;
	
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
	
	var devices_available = array_length(__INPUTCANDY.devices);
	for ( var k=0; k<__INPUTCANDY.max_players; k++ ) {
		if ( __INPUTCANDY.players[k].device >= devices_available ) __INPUTCANDY.players[k].device = none;
		ICUI_text( false, "Player "+int(k+1), ox+cw/2, oy );
		if ( !__INPUTCANDY.ui.device_select.inspecting ) {
		    r=rectangle(ox+cw/2-cw*0.375, oy+rh/2-rh*0.375, cw*0.75, rh*0.75);	
			if ( cwithin(mouse_x,mouse_y,r) ) {__INPUTCANDY.ui.device_select.menuitem=0; __INPUTCANDY.ui.device_select.influencing=k;}
			ICUI_surround_button( 
			 ( __INPUTCANDY.ui.device_select.influencing == k and __INPUTCANDY.ui.device_select.menuitem == 0 ),
			 r.x,r.y,r.w,r.h );
		}
		if ( k==__INPUTCANDY.player_using_keyboard_mouse ) {
			if ( __INPUTCANDY.players[k].device >= 0 ) {
				draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(__INPUTCANDY.devices[__INPUTCANDY.players[k].device]),ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.75, 0, c_white, 1.0 );
				draw_sprite_ext( s_InputCandy_device_icons, 0,ox+cw/2+cw/4,oy+rh/2+rh/4, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.25, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.25, 0, c_white, 1.0 );
			} else { // K3yb0@rd 0nly
				draw_sprite_ext( s_InputCandy_device_icons, 0,ox+cw/2,oy+rh/2, 1.0/sprite_get_width(s_InputCandy_device_icons)*swh*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*swh*0.75, 0, c_white, 1.0 );
			}
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
		
		var SDL_picker = (__INPUTCANDY.allow_SDL_remapping and global.SDLDB_Entries > 0);
		
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
		
		// Back button
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
			var sdlinfo="";
			if ( SDL_picker ) {
				sdlinfo=
				"SDL Name: "+device.sdl.name+"\n"
			   +"SDL DB matched? "+(string_length(device.sdl.remapping)>0?"Yes":"No")+"\n"
			   +"SDL Mapping Active:\n"+device.SDL_Mapping;
			}
			draw_sprite_ext( s_InputCandy_device_icons, __ICI.GuessBestDeviceIcon(device), topregion.x + topregion.h/2, topregion.y + topregion.h/2,
				1.0/sprite_get_width(s_InputCandy_device_icons)*cw*0.75, 1.0/sprite_get_height(s_InputCandy_device_icons)*rh*0.75, 0, c_white, 1.0 );
			draw_set_halign(fa_left);
			ICUI_text( false,
				"Gamepad: "+device.desc+" (Slot #"+int(player.device+1)+")\n"
			   +"GUID: "+device.guid+"\n"
			   +"Buttons: "+int(device.button_count)+"   Axis: "+int(device.axis_count)+"   Hats: "+int(device.hat_count)+"\n"
		       +sdlinfo,
			 rightside.x+rightside.w/2, rightside.y+rightside.h/2
			);
			draw_set_halign(fa_center);
		}
		
		sx = menu_margin+region.x;
		var max_menuitem= SDL_picker ? 4 : 3;
		sy += 5*btn_height+btn_height/5;
		r =rectangle( sx, sy, btn_width, btn_height );
		var mi=1;
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=mi;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == mi, "Select Different Gamepad", r.x,r.y,r.w,r.h );
		sy += btn_height+btn_height/5;
		mi++;
		if ( SDL_picker ) {
			r =rectangle( sx, sy, btn_width, btn_height );
			if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=mi;
			ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == mi, "Pick Gamepad SDL Remapping", r.x,r.y,r.w,r.h );
			sy += btn_height+btn_height/5;
			mi++;
		}
		r =rectangle( sx, sy, btn_width, btn_height );
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=mi;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == mi, "Customize Gamepad Input", r.x,r.y,r.w,r.h );
		sy += btn_height+btn_height/5;
		mi++;
		r =rectangle( sx, sy, btn_width, btn_height );
		if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=mi;
		ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == mi, "Test on Input Simulator", r.x,r.y,r.w,r.h );
		mi++;
		
		if ( player_index == __INPUTCANDY.player_using_keyboard_mouse ) {
			var kms="Keyboard and Mouse Settings";
			if ( device == none ) {}
			else if ( device.type == ICDeviceType_keyboard ) kms="Keyboard Settings";
			else if ( device.type == ICDeviceType_mouse ) kms="Mouse Settings";
			max_menuitem=mi;
			sy += btn_height+btn_height/5;
			r =rectangle( sx, sy, btn_width, btn_height );
			if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.device_select.menuitem=mi;
			ICUI_labeled_button( __INPUTCANDY.ui.device_select.menuitem == mi, kms, r.x,r.y,r.w,r.h );
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
			if ( SDL_picker ) switch ( __INPUTCANDY.ui.device_select.menuitem ) {
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
				 __INPUTCANDY.ui.SDLDB_select.mode=true;
				 __INPUTCANDY.ui.SDLDB_select.search_mode=-1;
				 ICUI_DoSearch(__INPUTCANDY.devices[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device],none);
				 __INPUTCANDY.ui.SDLDB_select.scrolled=__INPUTCANDY.ui.SDLDB_select.influencing;
				break;
				case 3:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.input_binding.mode=true;
				 __INPUTCANDY.ui.input_binding.influencing=-1;
				 __INPUTCANDY.ui.input_binding.scrolled=0;
				 __INPUTCANDY.ui.input_binding.keyboard_and_mouse=false;
				break;
				case 4:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.gamepad_test.mode=true;
				  __INPUTCANDY.ui.gamepad_test.expired=0.0;
				  __INPUTCANDY.ui.gamepad_test.exitting=false;
				break;
				case 5:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.input_binding.mode=true;
				 __INPUTCANDY.ui.input_binding.influencing=-1;
				 __INPUTCANDY.ui.input_binding.scrolled=0;
				 __INPUTCANDY.ui.input_binding.keyboard_and_mouse=true;
				break;
			} else switch ( __INPUTCANDY.ui.device_select.menuitem ) {
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
				 __INPUTCANDY.ui.input_binding.keyboard_and_mouse=false;
				break;
				case 3:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.gamepad_test.mode=true;
				break;
				case 4:
				audio_play_sound(a_ICUI_pageflip,100,0);
				 __INPUTCANDY.ui.device_select.mode=false;
				 __INPUTCANDY.ui.input_binding.mode=true;
				 __INPUTCANDY.ui.input_binding.influencing=-1;
				 __INPUTCANDY.ui.input_binding.scrolled=0;
				 __INPUTCANDY.ui.input_binding.keyboard_and_mouse=true;
				break;
			}
		}
	} else { // Controls have focus on background window
		
		var max_menuitem=__INPUTCANDY.max_players;
		
		// Back Button for background area of device_select (returns to ui's exit area)
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
				__ICI.UpdateActiveSetup();
				audio_play_sound(a_ICUI_pageflip,100,0);
				room_goto(exit_to);
			}				
		}
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_device_select_swapping() {
		
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
			default: // Swap device
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
				__ICI.UpdateActiveSetup();
				audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	}		
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_assure_settings_exist() {	
	var player_index=__INPUTCANDY.ui.device_select.influencing;
    // Create new settings if none exist, otherwise let the player choose existing settings or create new.
	if ( __INPUTCANDY.players[player_index].settings == none ) {
		if ( __INPUTCANDY.players[player_index].device == none ) {
			if ( player_index != __INPUTCANDY.player_using_keyboard_mouse or !__INPUTCANDY.ui.input_binding.keyboard_and_mouse ) { // Return to previous screen
				return false;
			} else if (array_length(__INPUTCANDY.settings) == 0 and __INPUTCANDY.ui.input_binding.keyboard_and_mouse) {
				__INPUTCANDY.settings[0]=__ICI.New_ICSettings();
				__INPUTCANDY.settings[0].deviceInfo=__ICI.New_ICDevice();
				__INPUTCANDY.settings[0].index=0;
				__INPUTCANDY.settings[0].deviceInfo.desc="Keyboard and Mouse";
				__INPUTCANDY.settings[0].deviceInfo.type=ICDeviceType_keyboard_mouse;
				__INPUTCANDY.players[player_index].settings = 0;
				__ICI.UpdateActiveSetup();
			}
		} else if ( array_length(__INPUTCANDY.settings) == 0 ) {
			__INPUTCANDY.settings[0]=__ICI.New_ICSettings();
			__INPUTCANDY.settings[0].deviceInfo=__INPUTCANDY.devices[__INPUTCANDY.players[player_index].device];
			__INPUTCANDY.settings[0].index=0;
			__INPUTCANDY.players[player_index].settings = 0;
			__INPUTCANDY.settings[0].deadzone1=gamepad_get_axis_deadzone(__INPUTCANDY.settings[0].deviceInfo.slot_id);
			__INPUTCANDY.settings[0].deadzone2=gamepad_get_button_threshold(__INPUTCANDY.settings[0].deviceInfo.slot_id);
			__ICI.UpdateActiveSetup();			
		} else { // Create new
			var settings_index = array_length(__INPUTCANDY.settings);
			__INPUTCANDY.settings[settings_index]=__ICI.New_ICSettings();
			__INPUTCANDY.settings[settings_index].deviceInfo=__INPUTCANDY.devices[__INPUTCANDY.players[player_index].device];
			__INPUTCANDY.settings[settings_index].index = settings_index;
			__INPUTCANDY.players[player_index].settings = settings_index;
			__INPUTCANDY.settings[settings_index].deadzone1=gamepad_get_axis_deadzone(__INPUTCANDY.settings[0].deviceInfo.slot_id);
			__INPUTCANDY.settings[settings_index].deadzone2=gamepad_get_button_threshold(__INPUTCANDY.settings[0].deviceInfo.slot_id);
			__ICI.UpdateActiveSetup();	
		}
	}
	return true;
}

function ICUI_Draw_input_binding() {
    if ( !ICUI_assure_settings_exist() ) {
     __INPUTCANDY.ui.device_select.mode=true;
	 __INPUTCANDY.ui.input_binding.mode=false;
	 return;
	}
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var settings_index=__INPUTCANDY.players[player_index].settings;
	
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
	
	if ( __INPUTCANDY.ui.input_binding.calibration ) {
		ICUI_Draw_input_binding_calibration();
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
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.influencing=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Input Settings #"+int(__INPUTCANDY.players[player_index].settings+1), ox+__INPUTCANDY.ui.region.w/2, oy );
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
		ICUI_text( false, "Keyboard and Mouse Configuration", ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	} else {
		ICUI_text( false, "(Created for "+__INPUTCANDY.settings[settings_index].deviceInfo.desc+")", ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	}
	oy+=smidge+eh*2;

      var buttons_region=rectangle( __INPUTCANDY.ui.region.x+eh, oy-eh, __INPUTCANDY.ui.region.w-(eh*5), eh );
	
	r=rectangle(buttons_region.x, buttons_region.y, buttons_region.w/2-smidge, buttons_region.h);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.influencing=mi_new;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_new, "New Profile", r.x,r.y,r.w,r.h );
	r=rectangle(buttons_region.x + buttons_region.w/2, buttons_region.y, buttons_region.w/2, buttons_region.h);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.influencing=mi_load;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_load, "Choose Profile", r.x,r.y,r.w,r.h );  
	  
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
			r=rectangle( ox + lines_region.w/2 - smidge/4, oy, lines_region.w/2, lineh);
			if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.influencing=i;
			ICUI_text_in_box( __INPUTCANDY.ui.input_binding.influencing == i, "", ox + lines_region.w/2 - smidge/4, oy, lines_region.w/2, lineh );
			if ( bound != none ) {
				if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
					ICUI_draw_ICaction( bound.bound_action.keyboard, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
					 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
					);
				}
				else
				ICUI_draw_ICaction( bound.bound_action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, action.mouse_keyboard_combo, 
				 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
				);
			} else {
				if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
					ICUI_draw_ICaction( action.keyboard, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
					 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
					);
				}
				else
				ICUI_draw_ICaction( action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, action.mouse_keyboard_combo, 
				 rectangle( ox + lines_region.w/2 - smidge/4 + smidge, oy+1, lines_region.w/2 - smidge*2 - smidge/2, lineh-2 )
				);
			}
			oy+=lineh+lineskip;
		}
		if ( cwithin(mouse_x,mouse_y,sb_dn) ) __INPUTCANDY.ui.input_binding.influencing=mi_scrdn;
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_scrdn, "", sb_dn.x,sb_dn.y,sb_dn.w,sb_dn.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 3, sb_dn.x, sb_dn.y, sb_dn.w, sb_dn.h, c_white, 0.65, 0, 0.5 );
		if ( cwithin(mouse_x,mouse_y,sb_up) ) __INPUTCANDY.ui.input_binding.influencing=mi_scrup;
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.influencing == mi_scrup, "", sb_up.x,sb_up.y,sb_up.w,sb_up.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 2, sb_up.x, sb_up.y, sb_up.w, sb_up.h, c_white, 0.65, 0, 0.5 );
		ICUI_box(sb_mid.x,sb_mid.y,sb_mid.w,sb_mid.h);
		var first_perc=(__INPUTCANDY.ui.input_binding.scrolled / bindable_actions);
		var last_perc=min(1.0,(__INPUTCANDY.ui.input_binding.scrolled+lines) / bindable_actions);
		var total_size=sb_mid.h-smidge*2;
		ICUI_tinted_box(__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2, sb_mid.x+smidge, sb_mid.y+smidge + total_size*first_perc, sb_mid.w-smidge*2, (total_size*last_perc)-(total_size*first_perc) );
	}

	if ( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings != none ) {
		if ( __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone1 != none ) {
			if ( cwithin(mouse_x,mouse_y,dz1) ) __INPUTCANDY.ui.input_binding.influencing=mi_dz1;
			ICUI_surround_button( __INPUTCANDY.ui.input_binding.influencing == mi_dz1, dz1.x, dz1.y, dz1.w, dz1.h );
		}
		if ( __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deadzone2 != none ) {
			if ( cwithin(mouse_x,mouse_y,dz2) ) __INPUTCANDY.ui.input_binding.influencing=mi_dz2;
			ICUI_surround_button( __INPUTCANDY.ui.input_binding.influencing == mi_dz2, dz2.x, dz2.y, dz2.w, dz2.h );
		}

		// Draw this part second (that's why the ifs are identical)
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
			__ICI.SaveSettings();
			break;
			case mi_new: // New Profile mode
			 {
				var next_profile = array_length(__INPUTCANDY.settings);
				if ( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device == none ) {
					if ( __INPUTCANDY.ui.device_select.influencing != 0 or !__INPUTCANDY.ui.input_binding.keyboard_mouse ) { // Return to previous screen
						__INPUTCANDY.ui.device_select.mode=true;
						__INPUTCANDY.ui.input_binding.mode=false;
						return;
					} else if (array_length(__INPUTCANDY.settings) == 0 and __INPUTCANDY.ui.input_binding.keyboard_mouse) {
					__INPUTCANDY.settings[next_profile]=__ICI.New_ICSettings();
					__INPUTCANDY.settings[next_profile]=next_profile;
					__INPUTCANDY.settings[next_profile].deviceInfo=__ICI.New_ICDevice();
					__INPUTCANDY.settings[next_profile].deviceInfo.desc="Keyboard and Mouse";
					__INPUTCANDY.settings[next_profile].deviceInfo.type=ICDeviceType_keyboard_mouse;
					__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings = next_profile;
					__ICI.UpdateActiveSetup();
					}
				} else {
					__INPUTCANDY.settings[next_profile]=__ICI.New_ICSettings();
					__INPUTCANDY.settings[next_profile].index=next_profile;
					var device_index=__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device;
					__INPUTCANDY.settings[next_profile].deviceInfo=__INPUTCANDY.devices[device_index];
					__INPUTCANDY.settings[next_profile].deadzone1=gamepad_get_axis_deadzone(__INPUTCANDY.settings[next_profile].deviceInfo.slot_id);
					__INPUTCANDY.settings[next_profile].deadzone2=gamepad_get_button_threshold(__INPUTCANDY.settings[next_profile].deviceInfo.slot_id);
					__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings = next_profile;
					__ICI.UpdateActiveSetup();
				}
				__INPUTCANDY.ui.input_binding.scrolled=0;
				__INPUTCANDY.ui.input_binding.influencing=mi_scrdn;
				audio_play_sound(a_ICUI_tone,100,0);
			 }
			break;
			case mi_load: // Choose Profile mode
			 __INPUTCANDY.ui.input_binding.loading=true;
			 __INPUTCANDY.ui.input_binding.loading_select=-1;
			 __INPUTCANDY.ui.input_binding.loading_scrolled=0;
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
	} else {
		if ( mouse_wheel_up() ) {
			 if ( __INPUTCANDY.ui.input_binding.scrolled > 0 ) __INPUTCANDY.ui.input_binding.scrolled--;
             audio_play_sound(a_ICUI_click,100,0);
        } else if ( mouse_wheel_down() ) {
			 if ( __INPUTCANDY.ui.input_binding.scrolled < bindable_actions - (lines - 1) ) __INPUTCANDY.ui.input_binding.scrolled++;
			 if ( __INPUTCANDY.ui.input_binding.scrolled < 0 ) __INPUTCANDY.ui.input_binding.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
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
	var oldfont   = draw_get_font();
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
		if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
			ICUI_draw_ICaction( bound.bound_action.keyboard, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
			 rectangle( ox + __INPUTCANDY.ui.region.w/4, oy, __INPUTCANDY.ui.region.w/2, eh*2 )
			);
		}
		else
		ICUI_draw_ICaction( bound.bound_action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, false, 
		 rectangle( ox + __INPUTCANDY.ui.region.w/4, oy, __INPUTCANDY.ui.region.w/2,  eh*2 )
		);
		oy-=smidge;
	} else {
		ICUI_text( false, "No Custom Binding", ox+__INPUTCANDY.ui.region.w/4, oy	);
	}
	
	ICUI_text( false, "Default:", ox+__INPUTCANDY.ui.region.w/4+__INPUTCANDY.ui.region.w/2, oy );	
	oy+=eh+smidge;
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
		ICUI_draw_ICaction( action.keyboard, ICDeviceType_keyboard, action.is_directional, action.keyboard_combo, action.mouse_keyboard_combo, 
		 rectangle( ox + __INPUTCANDY.ui.region.w/2, oy, __INPUTCANDY.ui.region.w/2,  eh*2 )
		);
	}
	else
	ICUI_draw_ICaction( action.gamepad, ICDeviceType_gamepad, action.is_directional, action.gamepad_combo, false, 
	 rectangle( ox + __INPUTCANDY.ui.region.w/2, oy, __INPUTCANDY.ui.region.w/2,  eh*2 )
	);
	oy+=smidge+eh*2;
	
	var sx=region.x;
	var sy=region.y;	
	
	var menu_margin=0.1*region.w;
	var btn_width=region.w-menu_margin*2;
	var btn_height=region.h/12;
	
	var calibratable = bound != none;
	if ( calibratable ) {
	    var km=__INPUTCANDY.player_using_keyboard_mouse == player_index and __INPUTCANDY.allow_keyboard_mouse and __INPUTCANDY.ui.input_binding.keyboard_and_mouse;
		if ( !km and bound.bound_action.is_directional ) {
		  var found=false;
		  if ( is_array(bound.bound_action) ) for ( i=0; i<array_length(bound.bound_action.gamepad); i++ ) {
			  if ( (bound.bound_action.gamepad[i] >= IC_stick_01 and bound.bound_action.gamepad[i] <= IC_stick_98)
			    or (bound.bound_action.gamepad[i] >= IC_axis0 and bound.bound_action.gamepad[i] <= IC_axis9) ) {
					found=true;
			  }
	  	  }
		  if ( found ) calibratable=true;
		  else calibratable=false;
		} else calibratable=false;
	}
	
	var max_menuitem=(calibratable?4:3);
	var mi_back=0;
	var mi_select_from_list=1;
	var mi_capture_input=2;
	var mi_set_to_default=3;
	// when is_directional:
	var mi_calibrate=4;

	// Back button
	r=rectangle(region.x, region.y, eh*2, eh*2);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,region.x+eh,region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);
	sy+=btn_height;

	sx = menu_margin+region.x;
	var max_menuitem=(action.is_directional?7:4);
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
	r =rectangle( sx, sy, btn_width, btn_height );
	if ( calibratable ) {
	 r =rectangle( sx, sy, btn_width, btn_height );
	 if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_calibrate;
	 ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_select == mi_calibrate,  "Change Calibration", r.x,r.y,r.w,r.h );
	}

	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.choosing_select++;
		if ( __INPUTCANDY.ui.input_binding.choosing_select > max_menuitem ) __INPUTCANDY.ui.device_select.choosing_select=0;
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
				__ICI.SaveSettings();
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
				__INPUTCANDY.ui.input_binding.choosing_capture=true;
				__INPUTCANDY.ui.input_binding.choosing_capture_expired=0.0;
				__INPUTCANDY.ui.input_binding.choosing_captures_2=false;
				__INPUTCANDY.ui.input_binding.choosing_capture_confirming=false;
				__INPUTCANDY.ui.input_binding.choosing_capture_select=0;				
			break;
			case mi_set_to_default:
				audio_play_sound(a_ICUI_tone,100,0);
				var b_index=__ICI.GetBinding( settings_index, action_index );
				if ( b_index != none ) {
						if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
							__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.keyboard=action.keyboard;
						} else {
							__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.gamepad=action.gamepad;
						}
				}
	 			__INPUTCANDY.ui.input_binding.choosing=false;
			break;
			case mi_calibration:
				audio_play_sound(a_ICUI_tone,100,0);
			 /* allow us to continue on and act like a cancel */
			 __INPUTCANDY.ui.input_binding.choosing_capture=false;
		 	 __INPUTCANDY.ui.input_binding.choosing_capture_confirming=false;
		     __INPUTCANDY.ui.input_binding.capture={ // Special mode where we're capturing input.
		         exitting: false,          // Leaving capturing mode
		         expired: 0.0,             // How long we've been attempting to capture.
		         select: 0,                 // Menu on page.
				 calibrating: 0,           // What we are calibrating
		         refresh_baseline: false,  // Turn this true to get a new baseline as we exit the capture frame.
		         baseline: none            // The baseline is a capture when we are beginning capture to detect changes.
		     };
			 __INPUTCANDY.ui.input_binding.calibrate_action=action;
			 __INPUTCANDY.ui.input_binding.calibration=true;
			 __INPUTCANDY.ui.input_binding.capture.captured=bound.bound_action.gamepad;
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
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) { // Setting up the options for Keyboard/Mouse config
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
	} else { // Gamepad device config
		target_deviceType=ICDeviceType_gamepad;
		target_is_combo = action.gamepad_combo;
		if ( action.is_directional ) {
			bindables[array_length(bindables)]={ type: ICDeviceType_gamepad, code: IC_dpad, name:"D-Pad" };
			var len=array_length(__INPUTCANDY.directionals);
			for ( var j=0; j<len; j++ ) {
				var d=__INPUTCANDY.directionals[j];
				if ( d.deviceType == ICDeviceType_gamepad and d.code != IC_dpad 
				 and ( (d.code >= IC_hat0 and d.code <= IC_hat9) or (d.code >= IC_stick_01 and d.code <= IC_stick_98) )
				 and __ICI.DirectionalSupported(device,j) )
				   bindables[array_length(bindables)]={ type: ICDeviceType_gamepad, code: d.code, name: d.name }
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
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_pick_select=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_pick_select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Input Settings #"+int(__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings+1), ox+__INPUTCANDY.ui.region.w/2, oy );
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
		ICUI_text( false, "Keyboard and Mouse Configuration", ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	} else {
		ICUI_text( false, "(Created for "+__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.desc+")",	ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	}
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
			r=rectangle(ox + lines_region.w/2 - smidge/4, oy, lines_region.w/2, lineh);
			if ( cwithin(mouse_x,mouse_y,r) ) is_focused=true;
			ICUI_text_in_box( false, bindables[i].name, ox,oy, lines_region.w/2-smidge/2, lineh );
			ICUI_text_in_box( is_focused, "", r.x,r.y,r.w,r.h );
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
						results+=string_replace(conflicting.bindings[k].bound_action.group+" "+conflicting.bindings[k].bound_action.name,"None ","");
						if ( k > 0 and (k!=conflicting.bindings_count-1) ) results+=",";
					}
					if ( string_length(results) > 0 and conflicting.actions_count > 0 ) {
						results+=" and ";
					}
					for ( var k=0; k<conflicting.actions_count; k++ ) {
						results+=string_replace(conflicting.actions[k].group+" "+conflicting.actions[k].name,"None ","");
						if ( k > 0 and  k!= (conflicting.actions_count-1) ) results+=",";
					}
					ICUI_text( false, results, lines_region.x+lines_region.w/2, lines_region.y2+eh*2 );
				}
			}
		}
		if ( cwithin(mouse_x,mouse_y,sb_dn) ) __INPUTCANDY.ui.input_binding.choosing_pick_select=mi_scrdn;
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.choosing_pick_select == mi_scrdn, "", sb_dn.x,sb_dn.y,sb_dn.w,sb_dn.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 3, sb_dn.x, sb_dn.y, sb_dn.w, sb_dn.h, c_white, 0.65, 0, 0.5 );
		if ( cwithin(mouse_x,mouse_y,sb_up) ) __INPUTCANDY.ui.input_binding.choosing_pick_select=mi_scrup;
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
					var b_index=__ICI.GetBinding(settings_index,action.index);
					if ( b_index < 0 ) {
						b_index=__ICI.AddBinding(settings_index,action.index);
					}
					if ( b.type == ICDeviceType_mouse ) {
						__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.mouse=b.code;
					} else if ( b.type == ICDeviceType_keyboard ) {
						__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.keyboard=b.code;
					} else {
						__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.gamepad=b.code;
					}
				}
			 	__INPUTCANDY.ui.input_binding.choosing=false;
				__INPUTCANDY.ui.input_binding.choosing_pick=false;
				__ICI.SaveSettings();
				audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	} else {
		if ( mouse_wheel_up() ) {
			 if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled > 0 ) __INPUTCANDY.ui.input_binding.choosing_pick_scrolled--;
             audio_play_sound(a_ICUI_click,100,0);
        } else if ( mouse_wheel_down() ) {
			 if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled < bindables_count - (lines - 1) ) __INPUTCANDY.ui.input_binding.choosing_pick_scrolled++;
			 if ( __INPUTCANDY.ui.input_binding.choosing_pick_scrolled < 0 ) __INPUTCANDY.ui.input_binding.choosing_pick_scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
		}
	}		

	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_sticktest( player_number,axis1, axis2, r, rotate, invert, reverse ) {
 var stick=__IC.GetStickSignal(player_number,axis1,axis2);
 ICUI_box( r.x,r.y,r.w,r.h );
 if ( !stick.not_available ) {
	 var h=(stick.H == AXIS_NO_VALUE ? 0 : stick.H);
	 var v=(stick.V == AXIS_NO_VALUE ? 0 : stick.V);
	 if ( rotate ) { var t=h; h=v; v=t; }
	 if ( invert ) { h=-h; }
	 if ( reverse ) { v=-v; }
	 var sh=string_format(h,1,1);
	 var sv=string_format(v,1,1);
	 h=h*0.5+0.5;
	 v=v*0.5+0.5;
	 var bs=r.w/10;
	 ICUI_box( r.x,r.y,r.w,r.h );
	 ICUI_tinted_box( c_white, c_gray, r.x+h*r.w-bs/2,r.y+v*r.h-bs/2,bs,bs );
	 ICUI_text_in_box(false,sh+","+sv,r.x,r.y2+r.h/12,r.w,r.h/4);
 }
}

function ICUI_Draw_input_binding_calibration() {
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
	
	var action_index=__INPUTCANDY.ui.input_binding.choosing_action;
	var action=__INPUTCANDY.actions[action_index];
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var player_number=player_index+1;
	var settings_index=__INPUTCANDY.players[player_index].settings;
	var settings = settings_index != none ? __INPUTCANDY.settings[settings_index] : none;
	var player=__INPUTCANDY.players[player_index];
	var device_index=__INPUTCANDY.players[player_index].device;
	var device=player.device==none?none:__INPUTCANDY.devices[player.device];
	var bound=__ICI.GetBindingData(settings_index,action_index);	
	var km=__INPUTCANDY.player_using_keyboard_mouse == player_index and __INPUTCANDY.allow_keyboard_mouse and __INPUTCANDY.ui.input_binding.keyboard_and_mouse;
	
	if ( bound == none or km ) {
		__INPUTCANDY.ui.input_binding.calibration=false;
		return;
	}

	var captured=bound.bound_action.gamepad;
	
	var sticks=0;
	var axes=0;
	var options=0;
	var clen = array_length(captured);
	for ( var f=0; f<clen; f++ ) {
		if ( captured[f] >= IC_stick_01 and captured[f] <= IC_stick_98 ) { options++; sticks++; }
		else if ( captured[f] >= IC_axis0 and captured[f] <= IC_axis9 ) { options++; axes++; }
	}
	
	var selected=__INPUTCANDY.ui.input_binding.capture.calibrating;
	if ( selected >= options ) {
		selected = options-1;
		__INPUTCANDY.ui.input_binding.calibrating=selected;
	}
	if ( selected < 0 ) { __INPUTCANDY.ui.input_binding.calibration=false; return; }
	var code=none;
	var code_index=none;
	var j=selected;
	for ( var f=0; f<clen; f++ ) {
		if ( (captured[f] >= IC_stick_01 and captured[f] <= IC_stick_98) or (captured[f] >= IC_axis0 and captured[f] <= IC_axis9) ) {
          j--;
		  if ( j < 0 ) {
			  code = captured[f];
			  code_index=f;
			  break;
	      }
		}
	}
	if ( code == none or code_index == none ) { __INPUTCANDY.ui.input_binding.calibration=false; return; }
	var typename="Neither";
	if (code >= IC_stick_01 and code <= IC_stick_98) typename="Stick";
	if (code >= IC_axis0 and code <= IC_axis9) typename="Axis";
	
	var target = bound.calibration[selected];

    // Draws a background
	ICUI_text_in_box( false, "", __INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, __INPUTCANDY.ui.region.w, __INPUTCANDY.ui.region.h );
	
	// Title
	oy+=eh;
	ICUI_text( false, "Calibrating Player #"+int(player_number)+"  Settings "+(settings==none?"(none)":("#"+int(settings_index+1))), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, km?"From Keyboard and Mouse":(device==none?"":("From "+device.desc)), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, "For action: "+action.name, ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, typename+" "+int(selected), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	
	oy+=eh*2;
	
	
    var max_menuitem=5;  // 0 Back button, 1 New Settings Profile, 2 Choose Settings Profile, 3/4 Up/Down Scroll, Deadzone1, Deadzone2
	var mi_back=max_menuitem-5;  // Back
	var mi_next=max_menuitem-4;   // New Profile
	var mi_prev=max_menuitem-3;  // Choose profile
	var mi_rotate=max_menuitem-2;   // Deadzone 1
	var mi_invert=max_menuitem-1;     // Deadzone 2
	var mi_reverse=max_menuitem; // Reverse

    var c=captured[selected];

	var r;
	
    r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  	ICUI_draw_ICaction(c,
	 km ? ICDeviceType_keyboard_mouse : ICDeviceType_gamepad,
	 action.is_directional,!km ? action.gamepad_combo : false,
	 km ? (action.mouse_combo or action.keyboard_combo or action.mouse_keyboard_combo): false,
	 r
	);	

	var r2=rectangle(r.x+r.w/2,r.y,eh*3,eh*3);
	if ( c >= IC_stick_01 and c<= IC_stick_98 ) {
		var d=__ICI.GetDirectionalByCode(c);
		var dir=__INPUTCANDY.directionals[d];
		ICUI_Draw_sticktest(player_number,dir.stickH,dir.stickV,r2, target.rotate, target.reverse, target.invert);
	}
		
	// Back Button
	var r=rectangle(__INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, eh*2, eh*2);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);
	
    var bw=__INPUTCANDY.ui.region.w/4;
	var btn_height=__INPUTCANDY.ui.region.h/12;
	var sx=__INPUTCANDY.ui.region.x2 - bw;
	var sy=__INPUTCANDY.ui.region.y + eh*4;

    if ( options > 1 ) {
	r =rectangle( sx, sy, bw, btn_height );
    ICUI_text_in_box( false, int(selected+1)+" of "+int(options), r.x, r.y, r.w, r.h );
	sy += btn_height+btn_height/5;

	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_next;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_next,    "  Next     >", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_prev;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_prev,    "< Previous  ", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	} else {
		if (__INPUTCANDY.ui.input_binding.capture.select >= mi_next or __INPUTCANDY.ui.input_binding.capture.select <= mi_prev ) __INPUTCANDY.ui.input_binding.capture.select = mi_back;
	}
	
	var indicator="On ";
	
	if ( typename != "Neither" ) {
	
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_rotate;
	if ( target.rotate ) indicator = "On "; else indicator = "Off";
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_rotate,  "["+(indicator)+"] Rotate    ", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_invert;
	if ( target.invert ) indicator = "On "; else indicator = "Off";
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_invert,  "["+(indicator)+"] Invert UD ", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_reverse;
	if ( target.reverse ) indicator = "On "; else indicator = "Off";
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_reverse, "["+(indicator)+"] Reverse LR", r.x,r.y,r.w,r.h );
	
	} else {
		if (__INPUTCANDY.ui.input_binding.capture.select >= mi_rotate or __INPUTCANDY.ui.input_binding.capture.select <= mi_reverse ) __INPUTCANDY.ui.input_binding.capture.select = mi_next;
	}

    var b_index=__ICI.GetBinding(settings_index,action.index);


	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.capture.select++;
		if ( __INPUTCANDY.ui.input_binding.capture.select > max_menuitem ) __INPUTCANDY.ui.input_binding.capture.select=0;		
		if ( options <= 1 ) { if (__INPUTCANDY.ui.input_binding.capture.select >= mi_next or __INPUTCANDY.ui.input_binding.capture.select <= mi_prev ) __INPUTCANDY.ui.input_binding.capture.select = mi_rotate; }
		if ( typename == "Neither" ) { if (__INPUTCANDY.ui.input_binding.capture.select >= mi_rotate or __INPUTCANDY.ui.input_binding.capture.select <= mi_reverse ) __INPUTCANDY.ui.input_binding.capture.select = mi_back; }
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.capture.select--;
		if ( __INPUTCANDY.ui.input_binding.capture.select < 0 ) __INPUTCANDY.ui.input_binding.capture.select=max_menuitem;
		if ( options <= 1 ) { if (__INPUTCANDY.ui.input_binding.capture.select >= mi_next or __INPUTCANDY.ui.input_binding.capture.select <= mi_prev ) __INPUTCANDY.ui.input_binding.capture.select = mi_back; }
		if ( typename == "Neither" ) { if (__INPUTCANDY.ui.input_binding.capture.select >= mi_rotate or __INPUTCANDY.ui.input_binding.capture.select <= mi_reverse ) __INPUTCANDY.ui.input_binding.capture.select = mi_back; }
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
		switch ( __INPUTCANDY.ui.input_binding.capture.select ) {
			case mi_back:
				audio_play_sound(a_ICUI_pageflip,100,0);
                __INPUTCANDY.ui.input_binding.calibration=false;
			break;
			case mi_next:
				audio_play_sound(a_ICUI_click,100,0);
				audio_play_sound(a_ICUI_tone,100,0);
				__INPUTCANDY.ui.input_binding.capture.calibrating++;
				if ( __INPUTCANDY.ui.input_binding.capture.calibrating >= options ) __INPUTCANDY.ui.input_binding.capture.calibrating=options-1;	
				if ( __INPUTCANDY.ui.input_binding.capture.calibrating < 0 ) __INPUTCANDY.ui.input_binding.capture.calibrating=0;			
			break;
			case mi_prev:
				audio_play_sound(a_ICUI_click,100,0);
				audio_play_sound(a_ICUI_tone,100,0);
				__INPUTCANDY.ui.input_binding.capture.calibrating--;
				if ( __INPUTCANDY.ui.input_binding.capture.calibrating < 0 ) __INPUTCANDY.ui.input_binding.capture.calibrating=0;
			break;
			case mi_rotate:
			 __INPUTCANDY.settings[settings_index].bindings[b_index].calibration[selected].rotate = !target.rotate;
             audio_play_sound(a_ICUI_tone,100,0);
			break;
			case mi_invert:
			 __INPUTCANDY.settings[settings_index].bindings[b_index].calibration[selected].invert = !target.invert;
             audio_play_sound(a_ICUI_tone,100,0);
			break;
			case mi_reverse:
			 __INPUTCANDY.settings[settings_index].bindings[b_index].calibration[selected].reverse = !target.reverse;
             audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_input_binding_choosing_capture_confirming() {
    if ( !ICUI_assure_settings_exist() ) {
     __INPUTCANDY.ui.device_select.mode=true;
	 __INPUTCANDY.ui.input_binding.mode=false;
	 return;
	}
	// How many input detected elements to display per line
	var test_wrap=floor( (__INPUTCANDY.ui.region.w*0.75) / 128);
	
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
	
	var action_index=__INPUTCANDY.ui.input_binding.choosing_action;
	var action=__INPUTCANDY.actions[action_index];
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var player_number=player_index+1;
	var settings_index=__INPUTCANDY.players[player_index].settings;
	var settings = settings_index != none ? __INPUTCANDY.settings[settings_index] : none;
	var player=__INPUTCANDY.players[player_index];
	var device_index=__INPUTCANDY.players[player_index].device;
	var device=player.device==none?none:__INPUTCANDY.devices[player.device];
	var bound=__ICI.GetBindingData(settings_index,action_index);	
	var km=__INPUTCANDY.player_using_keyboard_mouse == player_index and __INPUTCANDY.allow_keyboard_mouse and __INPUTCANDY.ui.input_binding.keyboard_and_mouse;

    // Draws a background
	ICUI_text_in_box( false, "", __INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, __INPUTCANDY.ui.region.w, __INPUTCANDY.ui.region.h );
	
	// Title
	oy+=eh;
	ICUI_text( false, "Capturing for Player #"+int(player_number)+"  Settings "+(settings==none?"(none)":("#"+int(settings_index+1))), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, km?"From Keyboard and Mouse":(device==none?"":("From "+device.desc)), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, "For action: "+action.name, ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	
	oy+=eh*2;
	
	var r;
	
    r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  	ICUI_draw_ICaction(__INPUTCANDY.ui.input_binding.capture.captured,
	 km ? ICDeviceType_keyboard_mouse : ICDeviceType_gamepad,
	 action.is_directional,!km ? action.gamepad_combo : false,
	 km ? (action.mouse_combo or action.keyboard_combo or action.mouse_keyboard_combo): false,
	 r
	);
	
	var clen=array_length(__INPUTCANDY.ui.input_binding.capture.captured);
	var r2=rectangle(r.x,r.y+eh*2,eh*3,eh*3);
	for ( var k=0; k<clen; k++ ) {
	    var c=__INPUTCANDY.ui.input_binding.capture.captured[k];
		if ( c >= IC_stick_01 and c<= IC_stick_98 ) {
			var d=__ICI.GetDirectionalByCode(c);
			var dir=__INPUTCANDY.directionals[d];
			ICUI_Draw_sticktest(player_number,dir.stickH,dir.stickV,r2, false,false,false);
			r2=rectangle(r2.x+smidge+r2.w,r2.y,r2.w,r2.h);
		}
	}
	
	var conflicting=__ICI.GetActionsBindingsByCode( settings_index, __INPUTCANDY.ui.input_binding.capture.captured, bound == none ? none : bound.index, action_index );
	if ( conflicting.bindings_count > 0 or conflicting.actions_count > 0 ) {
        var lines_region=rectangle(__INPUTCANDY.ui.region.x+eh,oy+smidge,__INPUTCANDY.ui.region.w-(eh*5),__INPUTCANDY.ui.region.y2-oy-eh*3);
		ICUI_text( false, "Warning: already in use by", lines_region.x+lines_region.w/2, lines_region.y2+eh );
		var results="";
		for ( var k=0; k<conflicting.bindings_count; k++ ) {
			results+=string_replace(conflicting.bindings[k].bound_action.group+" "+conflicting.bindings[k].bound_action.name,"None ","");
			if ( k > 0 and (k!=conflicting.bindings_count-1) ) results+=",";
		}
		if ( string_length(results) > 0 and conflicting.actions_count > 0 ) {
			results+=" and ";
		}
		for ( var k=0; k<conflicting.actions_count; k++ ) {
			results+=string_replace(conflicting.actions[k].group+" "+conflicting.actions[k].name,"None ","");
			if ( k > 0 and  k!= (conflicting.actions_count-1) ) results+=",";
		}
		ICUI_text( false, results, lines_region.x+lines_region.w/2, lines_region.y2+eh*2 );
	}

    var max_menuitem=2;  // 0 Back button, 1 New Settings Profile, 2 Choose Settings Profile, 3/4 Up/Down Scroll, Deadzone1, Deadzone2
	var mi_calibrate=max_menuitem-3; // Calibrate / Reverse / Invert axis or sticks
	var mi_back=max_menuitem-2;    // Back / Capture again
	var mi_accept=max_menuitem-1;  // Accept this capture
	var mi_cancel=max_menuitem;    // Abort capturing.

	var sticks=0;
	var axes=0;
	var clen = array_length(__INPUTCANDY.ui.input_binding.capture.captured);
	for ( var f=0; f<clen; f++ ) {
		if ( __INPUTCANDY.ui.input_binding.capture.captured[f] >= IC_stick_01 and __INPUTCANDY.ui.input_binding.capture.captured[f] <= IC_stick_98 ) sticks++;
		else if ( __INPUTCANDY.ui.input_binding.capture.captured[f] >= IC_axis0 and __INPUTCANDY.ui.input_binding.capture.captured[f] <= IC_axis9 ) axes++;
	}
	var allow_calibration=!km and ( axes > 0 or (sticks > 0 and action.is_directional) );
	if ( allow_calibration ) {
        max_menuitem=3;  // 0 Back button, 1 New Settings Profile, 2 Choose Settings Profile, 3/4 Up/Down Scroll, Deadzone1, Deadzone2
	    mi_back=max_menuitem-3;    // Back / Capture again
	    mi_calibrate=max_menuitem-2; // Calibrate / Reverse / Invert axis or sticks
	    mi_accept=max_menuitem-1;  // Accept this capture
	    mi_cancel=max_menuitem;    // Abort capturing.
	} else {
        max_menuitem=2;  // 0 Back button, 1 New Settings Profile, 2 Choose Settings Profile, 3/4 Up/Down Scroll, Deadzone1, Deadzone2
	    mi_back=max_menuitem-2;    // Back / Capture again
	    mi_accept=max_menuitem-1;  // Accept this capture
	    mi_cancel=max_menuitem;    // Abort capturing.
	}
	
	// Back Button
	var r=rectangle(__INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, eh*2, eh*2);
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.capture.select=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);
	
    var bw=__INPUTCANDY.ui.region.w/4;
	var btn_height=__INPUTCANDY.ui.region.h/12;
	var sx=__INPUTCANDY.ui.region.x2 - bw;
	var sy=__INPUTCANDY.ui.region.y2 - (btn_height+btn_height/5)*( allow_calibration ? 3 : 2 );
	
	if ( allow_calibration ) {
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_calibrate;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_calibrate, "Save then Calibrate", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	}
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_accept;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_accept, "Accept", r.x,r.y,r.w,r.h );
	sy += btn_height+btn_height/5;
	r =rectangle( sx, sy, bw, btn_height );
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.choosing_select=mi_cancel;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.capture.select == mi_cancel, "Cancel", r.x,r.y,r.w,r.h );
	
	
	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.capture.select+=1;
		if ( __INPUTCANDY.ui.input_binding.capture.select > max_menuitem ) __INPUTCANDY.ui.input_binding.capture.select=0;
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.capture.select-=1;
		if ( __INPUTCANDY.ui.input_binding.capture.select < 0 ) __INPUTCANDY.ui.input_binding.capture.select=max_menuitem;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.input_binding.capture.select ) {
			case mi_back: // Abort / go back / cancel
		 	 __INPUTCANDY.ui.input_binding.choosing_capture_confirming=false;
		     __INPUTCANDY.ui.input_binding.capture={ // Special mode where we're capturing input.
		         exitting: false,          // Leaving capturing mode
		         expired: 0.0,             // How long we've been attempting to capture.
		         select: 0,                 // Menu on confirming page.
		         refresh_baseline: false,  // Turn this true to get a new baseline as we exit the capture frame.
		         baseline: none            // The baseline is a capture when we are beginning capture to detect changes.
		     };
			 audio_play_sound(a_ICUI_pageflip,100,0);
			__ICI.SaveSettings();
			break;
			case mi_calibrate: // Accept/Save, then turn on the capture wizard
			 var b_index=__ICI.GetBinding(settings_index,action.index);
			 if ( b_index < 0 ) b_index=__ICI.AddBinding(settings_index,action.index);
			 if ( km ) {
				 var keys=[]
				 var mice=[]
				 var len=array_length(__INPUTCANDY.ui.input_binding.capture.captured);
				 for ( var i=0; i<len; i++ ) {
					 var value=__INPUTCANDY.ui.input_binding.capture.captured[i];
					 if ( value == IC_mouse_left or value == IC_mouse_right or value == IC_mouse_middle
					   or value == IC_mouse_scrolldown || value == IC_mouse_scrollup ) mice[array_length(mice)]=value;
					 else keys[array_length(keys)]=value;
				 }
			 	 __INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.mouse=mice;
			 	 __INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.keyboard=keys;
			 } else { // Gamepad...
			 	__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.gamepad=__INPUTCANDY.ui.input_binding.capture.captured;		
				// Set up empty calibration settings for directionals
				if ( __INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.is_directional ) {
					__INPUTCANDY.settings[settings_index].bindings[b_index].calibration=[]
					for ( i=0; i<array_length(__INPUTCANDY.ui.input_binding.capture.captured); i++ ) {
						__INPUTCANDY.settings[settings_index].bindings[b_index].calibration[i]={ rotate: false, invert: false, reverse: false };
					}
				}
				__INPUTCANDY.ui.input_binding.capture.select=0;				
			 }
			 /* allow us to continue on and act like a cancel */
			 __INPUTCANDY.ui.input_binding.choosing_capture=false;
		 	 __INPUTCANDY.ui.input_binding.choosing_capture_confirming=false;
		     __INPUTCANDY.ui.input_binding.capture={ // Special mode where we're capturing input.
		         exitting: false,          // Leaving capturing mode
		         expired: 0.0,             // How long we've been attempting to capture.
		         select: 0,                 // Menu on page.
				 calibrating: 0,           // What we are calibrating
		         refresh_baseline: false,  // Turn this true to get a new baseline as we exit the capture frame.
		         baseline: none            // The baseline is a capture when we are beginning capture to detect changes.
		     };
			 __INPUTCANDY.ui.input_binding.calibrate_action=action;
			 __INPUTCANDY.ui.input_binding.calibration=true;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			
			break;
			case mi_accept: // Assign the capture codes to the action and its appropriate device
			 var b_index=__ICI.GetBinding(settings_index,action.index);
			 if ( b_index < 0 ) b_index=__ICI.AddBinding(settings_index,action.index);
			 if ( km ) {
				 var keys=[]
				 var mice=[]
				 var len=array_length(__INPUTCANDY.ui.input_binding.capture.captured);
				 for ( var i=0; i<len; i++ ) {
					 var value=__INPUTCANDY.ui.input_binding.capture.captured[i];
					 if ( value == IC_mouse_left or value == IC_mouse_right or value == IC_mouse_middle
					   or value == IC_mouse_scrolldown || value == IC_mouse_scrollup ) mice[array_length(mice)]=value;
					 else keys[array_length(keys)]=value;
				 }
				 if ( array_length(mice) > 0 ) {
			 	  __INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.mouse=b.code;
				 }
				 if ( array_length(keys) > 0 ) {
			 	  __INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.keyboard=b.code;
				 }
			 } else { // Gamepad...
			 	__INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.gamepad=__INPUTCANDY.ui.input_binding.capture.captured;
				// Set up empty calibration settings for directionals
				if ( __INPUTCANDY.settings[settings_index].bindings[b_index].bound_action.is_directional ) {
					__INPUTCANDY.settings[settings_index].bindings[b_index].calibration=[]
					for ( i=0; i<array_length(__INPUTCANDY.ui.input_binding.capture.captured); i++ ) {
						__INPUTCANDY.settings[settings_index].bindings[b_index].calibration[i]={ rotate: false, invert: false, reverse: false };
					}
				}
				__INPUTCANDY.ui.input_binding.capture.select=0;
			 }
			 /* allow us to continue on and act like a cancel */
			case mi_cancel: // Cancel capturing altogether
			 __INPUTCANDY.ui.input_binding.choosing_capture=false;
		 	 __INPUTCANDY.ui.input_binding.choosing_capture_confirming=false;
		     __INPUTCANDY.ui.input_binding.capture={ // Special mode where we're capturing input.
		         exitting: false,          // Leaving capturing mode
		         expired: 0.0,             // How long we've been attempting to capture.
		         select: 0,                 // Menu on confirming page.
		         refresh_baseline: false,  // Turn this true to get a new baseline as we exit the capture frame.
		         baseline: none            // The baseline is a capture when we are beginning capture to detect changes.
		     };
             audio_play_sound(a_ICUI_click,100,0);
			break;
//			case mi_rotate:
//			case mi_invert:
//			case mi_reverse:
			default:
			break;
		}
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_input_binding_choice_capture() {
	
	if ( __INPUTCANDY.ui.input_binding.choosing_capture_confirming ) {
		ICUI_Draw_input_binding_choosing_capture_confirming();
		return;
	}
	
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var player_number=player_index+1;
	var player=__INPUTCANDY.players[player_index];
	var km=__INPUTCANDY.player_using_keyboard_mouse == player_index and __INPUTCANDY.allow_keyboard_mouse and __INPUTCANDY.ui.input_binding.keyboard_and_mouse;

	var device_index=__INPUTCANDY.players[player_index].device;
	var device=player.device==none?none:__INPUTCANDY.devices[player.device];
	
	if ( device == none and !km ) {
		__INPUTCANDY.ui.input_binding.choosing_capture=false;
		return;
	}
	
	var settings_index=__INPUTCANDY.players[player_index].settings;
	var settings=settings_index==none ? none : __INPUTCANDY.settings[settings_index];
	var action_index=__INPUTCANDY.ui.input_binding.choosing_action;
	var action=__INPUTCANDY.actions[action_index];
	
	// How many input detected elements to display per line
	var test_wrap=floor( (__INPUTCANDY.ui.region.w*0.75) / 128);
	
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
	
	// Title
	oy+=eh;
	ICUI_text( false, "Capturing for Player #"+int(player_number)+"  Settings "+(settings==none?"(none)":("#"+int(settings_index+1))), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, km?"From Keyboard and Mouse":(device==none?"":("From "+device.desc)), ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
	ICUI_text( false, "For action: "+action.name, ox+__INPUTCANDY.ui.region.w/2, oy );
	oy+=eh;
    var held=ICUI_capture_duration_s-__INPUTCANDY.ui.input_binding.capture.expired;
	if ( held < 0 )	ICUI_text( false, "Please Release",  ox+__INPUTCANDY.ui.region.w/2, oy+eh*2 );
	else {
		ICUI_text( false, "Hold one or more buttons or diagonal with sticks for "+int(held)+" seconds to capture",  ox+__INPUTCANDY.ui.region.w/2, oy+eh*2 );
	}
	oy+=smidge+eh*3;
		
	var found=false;
	var r;
	
	// Codes we captured.
	var captured=[];

    if ( !km and device != none ) {
     if ( !action.is_directional ) {
       var len =array_length(__INPUTCANDY.states[player.device].signals);
       var codes=[];
       var j=0;
       for ( i=0; i<len; i++ ) if ( __INPUTCANDY.states[player.device].signals[i].is_held ) {
       	 codes[j]=__INPUTCANDY.states[player.device].signals[i].signal_index;
		 captured[array_length(captured)]=codes[j];
       	 j++;
       	 if ( j == test_wrap ) {
       		r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
       		ICUI_draw_ICaction(codes,ICDeviceType_gamepad,false,true,false,r);
       		 oy+=smidge+eh*3;
       		 codes=[];
       		 j=0;
       	 }
       }
       if ( array_length(codes) > 0 ) {
       	 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
       	 ICUI_draw_ICaction(codes,ICDeviceType_gamepad,false,true,false,r);
       	 oy+=smidge+eh*3;
       }
     } else { // Directional on Gamepad
	
	  var state=__INPUTCANDY.states[player.device];
	  
      if ( __IC.Signal( player_number, IC_padd ) or __IC.Signal( player_number, IC_padu ) or __IC.Signal( player_number, IC_padl ) or __IC.Signal( player_number, IC_padr ) ) {
	     captured[array_length(captured)]=IC_dpad;
         r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/3,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
         ICUI_image( s_InputCandy_ICUI_icons, 4, r.x-__INPUTCANDY.ui.region.w/8, r.y, eh, eh, c_white, 0, 1.0 );
	  	 ICUI_text( false, "(D-Pad)", r.x, r.y );
	  	 oy += smidge+eh;
	  }
   
	   var k=0;
	   for ( k=0; k<__INPUTCANDY.devices[player.device].hat_count; k++ ) {
	  	 var hat_state=__IC.GetHatSignal(player_number,k);
	  	 if ( !hat_state.not_available and (hat_state.H != AXIS_NO_VALUE or hat_state.V != AXIS_NO_VALUE) and ( abs(hat_state.V) > 0.5 or abs(hat_state.H) > 0.5 ) ) {
	  		r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/3,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
             ICUI_image( s_InputCandy_ICUI_icons, 17, r.x-__INPUTCANDY.ui.region.w/8, r.y, eh, eh, c_white, 0, 1.0 );
	  		ICUI_text( false, "(On Hat #"+int(k)+")", r.x, r.y );
            captured[array_length(captured)]=IC_hat0+k;
	  		oy += smidge+eh;
	  	 }
	   }
	   
	   if ( __INPUTCANDY.devices[player.device].axis_count > 1 ) {
		var pairs=[]
	    for ( k=0; k<__INPUTCANDY.devices[player.device].axis_count; k++ ) {
		 for ( l=0; l<__INPUTCANDY.devices[player.device].axis_count; l++ ) {
			 if ( l==k ) continue;
			 var len=array_length(pairs);
			 var fondu=false;
			 for ( m=0; m<len; m++ ) {
				 if ( (pairs[m].a == k or pairs[m].b == k) or (pairs[m].a == l or pairs[m].b == l) ) { fondu=true; break; }
			 }
			 if ( fondu ) continue;
			 pairs[len] = { a: k, b: l };
//			 if ( !__ICI.DirectionalSupported(device,k,l) ) continue;
  			 var stick=__IC.GetStickSignal(player_number,k,l);
  			 if ( !stick.not_available and (stick.H != AXIS_NO_VALUE and stick.V != AXIS_NO_VALUE) and ( abs(stick.V) > 0.5 and abs(stick.H) > 0.5 ) ) {
					pair=__ICI.GetStickByAxisPair(k,l);
					if ( pair==none ) continue;
					pair=__INPUTCANDY.directionals[pair];
					captured[array_length(captured)]=pair.code;
	  		    	r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/3,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
			        ICUI_image( s_InputCandy_ICUI_icons, 17, r.x-__INPUTCANDY.ui.region.w/8, r.y, eh, eh, c_white, 0, 1.0 );
	  		    	ICUI_text( false, "(Stick #"+int(k)+", Axes "+int(k)+","+int(l)+")", r.x, r.y );
	  		    	oy += smidge+eh;
  			 }
		 }
        }
	   }  
	}	 
	 
   } else if ( km ) {
	 var len =array_length(__INPUTCANDY.mouseStates);
	 if ( len > 0 ) found=true;
	 var codes=[];
	 var j=0;
	 for ( i=0; i<len; i++ ) if ( __INPUTCANDY.mouseStates[i].is_held ) {
		 codes[j]=__INPUTCANDY.mouseStates[i].signal_index;
		 captured[array_length(captured)]=codes[j];
		 j++;
		 if ( j == test_wrap ) {
			r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  			ICUI_draw_ICaction(codes,ICDeviceType_mouse,false,true,false,r);
			 oy+=smidge+eh*2;
			 codes=[];
			 j=0;
		 }
	 }
	 if ( array_length(codes) > 0 ) {
		 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
		 ICUI_draw_ICaction(codes,ICDeviceType_mouse,false,true,false,r);
		 oy+=smidge+eh*2;
	 }
	 len =array_length(__INPUTCANDY.keys);
	 if ( len > 0 ) found=true;
	 var codes=[];
	 var j=0;
	 for ( i=0; i<len; i++ ) if ( __INPUTCANDY.keys[i].is_held ) {
		 codes[j]=__INPUTCANDY.keys[i].signal_index;
		 captured[array_length(captured)]=codes[j];
		 j++;
		 if ( j == test_wrap ) {
			r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  			ICUI_draw_ICaction(codes,ICDeviceType_keyboard,false,true,false,r);
			 oy+=smidge+eh*2;
			 codes=[];
			 j=0;
		 }
	 }
	 if ( array_length(codes) > 0 ) {
		 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
		 ICUI_draw_ICaction(codes,ICDeviceType_keyboard,false,true,false,r);
		 oy+=smidge+eh*2;
	 }
	}
	
	found=array_length(captured)>0;
	
	if ( found ) {		
	  		r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/3,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
	  		ICUI_text( false, "Found: "+int(array_length(captured)), r.x, r.y );
	  		oy += smidge+eh;
	}
	
	if ( !__INPUTCANDY.ui.input_binding.capture.exitting ) {
		if ( found == false ) __INPUTCANDY.ui.input_binding.capture.expired=0;
	    else {
			__INPUTCANDY.ui.input_binding.capture.expired += 1.0/room_speed;
	        if ( __INPUTCANDY.ui.input_binding.capture.expired > ICUI_capture_duration_s ) {
	        	__INPUTCANDY.ui.input_binding.capture.captured=captured;
				__INPUTCANDY.ui.input_binding.capture.calibrating=0;
	        	__INPUTCANDY.ui.input_binding.capture.exitting=true;
			   audio_play_sound(a_ICUI_tone,100,0);
			}
		}
	}
	if ( __INPUTCANDY.ui.input_binding.capture.exitting and !found ) {
	    __INPUTCANDY.ui.input_binding.choosing_capture_confirming=true;
	    audio_play_sound(a_ICUI_pageflip,100,0);
	}
	
	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}


function ICUI_Draw_input_binding_set_profile() {

    var settings_count=array_length(__INPUTCANDY.settings);
	var player_index=__INPUTCANDY.ui.device_select.influencing;
    var settings_index=__INPUTCANDY.players[player_index].settings;
	if ( settings_index == none ) {
       if ( !ICUI_assure_settings_exist() ) {
			__INPUTCANDY.ui.device_select.mode=true;
			__INPUTCANDY.ui.input_binding.mode=false;
			__INPUTCANDY.ui.input_binding.loading=false;
	   }
	   return;
	}

    var max_menuitem=settings_count+2;  // 0 Back button, 2/3 Up/Down Scroll
	var mi_back=max_menuitem-2;  // Back
	var mi_scrup=max_menuitem-1; // Up
	var mi_scrdn=max_menuitem; // Down
	if ( __INPUTCANDY.ui.input_binding.loading_select < 0 ) {
		__INPUTCANDY.ui.input_binding.loading_select=mi_back;
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
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.loading_select=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.input_binding.loading_select == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Current Settings: Profile #"+int(__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings+1), ox+__INPUTCANDY.ui.region.w/2, oy );
	if ( __INPUTCANDY.ui.input_binding.keyboard_and_mouse ) {
		ICUI_text( false, "Keyboard and Mouse Configuration", ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	} else if ( __INPUTCANDY.settings[settings_index].deviceInfo != none ) {
		var desc=__INPUTCANDY.settings[settings_index].deviceInfo.desc;
		ICUI_text( false, "(Created for "+desc+")", ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	}
	oy+=smidge+eh*2;
	

      var buttons_region=rectangle( __INPUTCANDY.ui.region.x+eh, oy-eh, __INPUTCANDY.ui.region.w-(eh*5), eh );
	  
	  var lines_region=rectangle(__INPUTCANDY.ui.region.x+eh,oy+smidge,__INPUTCANDY.ui.region.w-(eh*5),__INPUTCANDY.ui.region.y2-oy-eh*3);
	  var lineh=eh*2;
	  var lineskip=smidge;
	  var lines=floor(lines_region.h / (lineh+lineskip));
	  var sb_region=rectangle(lines_region.x2+eh/2,lines_region.y,eh*2,lines_region.h);
	  var sb_up=rectangle(sb_region.x,sb_region.y,sb_region.w,sb_region.w);
	  var sb_dn=rectangle(sb_region.x,sb_region.y+sb_region.h-sb_up.h,sb_up.w,sb_up.h);
	  var sb_mid=rectangle(sb_up.x,sb_up.y2,sb_region.w,sb_region.h-sb_up.h*2);

	var start_item=__INPUTCANDY.ui.input_binding.loading_scrolled;
	var end_item=min(settings_count-1,start_item+lines-1);

	if ( settings_count > 0 ) {
	    ox=lines_region.x;
		oy=lines_region.y;
		for ( var i=start_item; (i<settings_count) and (i-start_item<lines); i++ ) {
			r=rectangle(ox,oy, lines_region.w-smidge/2, lineh);
			if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.input_binding.loading_select=i;
			ICUI_text_in_box(  __INPUTCANDY.ui.input_binding.loading_select == i, "Settings #"+int(i+1)+" ("+__INPUTCANDY.settings[i].deviceInfo.desc+")", r.x,r.y,r.w,r.h );
			oy+=lineh+lineskip;
		}
		if ( cwithin(mouse_x,mouse_y,sb_dn) ) __INPUTCANDY.ui.input_binding.loading_select=mi_scrdn;
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.loading_select == mi_scrdn, "", sb_dn.x,sb_dn.y,sb_dn.w,sb_dn.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 3, sb_dn.x, sb_dn.y, sb_dn.w, sb_dn.h, c_white, 0.65, 0, 0.5 );
		if ( cwithin(mouse_x,mouse_y,sb_up) ) __INPUTCANDY.ui.input_binding.loading_select=mi_scrup;
		ICUI_labeled_button( __INPUTCANDY.ui.input_binding.loading_select == mi_scrup, "", sb_up.x,sb_up.y,sb_up.w,sb_up.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 2, sb_up.x, sb_up.y, sb_up.w, sb_up.h, c_white, 0.65, 0, 0.5 );
		ICUI_box(sb_mid.x,sb_mid.y,sb_mid.w,sb_mid.h);
		var first_perc=(__INPUTCANDY.ui.input_binding.loading_scrolled / settings_count);
		var last_perc=min(1.0,(__INPUTCANDY.ui.input_binding.loading_scrolled+lines) / settings_count);
		var total_size=sb_mid.h-smidge*2;
		ICUI_tinted_box(__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2, sb_mid.x+smidge, sb_mid.y+smidge + total_size*first_perc, sb_mid.w-smidge*2, (total_size*last_perc)-(total_size*first_perc) );
	}
	
	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.loading_select++;
		if ( __INPUTCANDY.ui.input_binding.loading_select == end_item+1 and end_item < settings_count ) __INPUTCANDY.ui.input_binding.loading_select=mi_scrdn;
		if ( __INPUTCANDY.ui.input_binding.loading_select > max_menuitem ) {
			__INPUTCANDY.ui.input_binding.loading_select=__INPUTCANDY.ui.input_binding.loading_scrolled;
		}
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.input_binding.loading_select--;
		if ( __INPUTCANDY.ui.input_binding.loading_select < 0 ) __INPUTCANDY.ui.input_binding.loading_select=max_menuitem;
		if ( __INPUTCANDY.ui.input_binding.loading_scrolled > 0 and __INPUTCANDY.ui.input_binding.loading_select == __INPUTCANDY.ui.input_binding.loading_scrolled-1 ) __INPUTCANDY.ui.input_binding.loading_select=mi_scrup;
		if ( __INPUTCANDY.ui.input_binding.loading_select == mi_back-1 ) __INPUTCANDY.ui.input_binding.loading_select=end_item;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.input_binding.loading_select ) {
			case mi_back: // Abort / go back / cancel
		 	 __INPUTCANDY.ui.input_binding.loading=false;
			 audio_play_sound(a_ICUI_pageflip,100,0);
			break;
			case mi_scrup: // Scroll up
			 if ( __INPUTCANDY.ui.input_binding.loading_scrolled > 0 ) __INPUTCANDY.ui.input_binding.loading_scrolled--;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_scrdn: // Scroll down
			 if ( __INPUTCANDY.ui.input_binding.loading_scrolled < settings_count - (lines - 1) ) __INPUTCANDY.ui.input_binding.loading_scrolled++;
			 if ( __INPUTCANDY.ui.input_binding.loading_scrolled < 0 ) __INPUTCANDY.ui.input_binding.loading_scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			default:
				__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings=__INPUTCANDY.ui.input_binding.loading_select;
			 	 __INPUTCANDY.ui.input_binding.loading=false;
				audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	} else {
		if ( mouse_wheel_up() ) {
			 if ( __INPUTCANDY.ui.input_binding.loading_scrolled > 0 ) __INPUTCANDY.ui.input_binding.loading_scrolled--;
             audio_play_sound(a_ICUI_click,100,0);
        } else if ( mouse_wheel_down() ) {
			 if ( __INPUTCANDY.ui.input_binding.loading_scrolled < settings_count - (lines - 1) ) __INPUTCANDY.ui.input_binding.loading_scrolled++;
			 if ( __INPUTCANDY.ui.input_binding.loading_scrolled < 0 ) __INPUTCANDY.ui.input_binding.loading_scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
		}
	}

	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_MinSearchMode() {	return -1; }

function ICUI_SDLDB_Search_Character() {
	switch ( floor(__INPUTCANDY.ui.SDLDB_select.search_mode) ) {
		 case -1: return "#";
		 case 0: return "*";
		 case 1: return "A";		 case 2: return "B";		 case 3: return "C";		 case 4: return "D";		 case 5: return "E";
		 case 6: return "F";		 case 7: return "G";		 case 8: return "H";		 case 9: return "I";		case 10: return "J";
		case 11: return "K";		case 12: return "L";		case 13: return "M";		case 14: return "N";		case 15: return "O";
		case 16: return "P";		case 17: return "Q";		case 18: return "R";		case 19: return "S";		case 20: return "T";
		case 21: return "U";		case 22: return "V";		case 23: return "W";		case 24: return "X";		case 25: return "Y";
		case 26: return "Z";
		case 27: return "0";		case 28: return "1";		case 29: return "2";		case 30: return "3";		case 31: return "4";
		case 32: return "5";		case 33: return "6";		case 34: return "7";		case 35: return "8";		case 36: return "9";
		default: return "A";
	}
}

function ICUI_MaxSearchMode() {	return 36; }



// Return the name of the search mode
function ICUI_SDLDB_Mode() {
	switch ( __INPUTCANDY.ui.SDLDB_select.search_mode%37 ) {
		case -1: return "Matching GUID";
		case 0: return "Closest Name";
		default: return "Starts with "+ICUI_SDLDB_Search_Character();
	}
}

function ICUI_trim(s) {
	var char=" ";
	var new_string = s;
	var len=string_length(new_string);
	var _start = 0;
	for(var i=1;i <= len;i++) if (string_char_at(new_string, i) != char) {
		_start = i - 1;
		break;
	}
	if (_start != 0) new_string = string_delete(new_string,1,_start);
	var _end = 0;
	len=string_length(new_string);
	for ( var i=len; i > 0; i-- ) if (string_char_at(new_string, i) != char) {
		_end = i + 1;
		break;
	}
	if (_end != 0) {
		new_string = string_delete(new_string,_end,string_length(new_string));
	}
	return new_string;
}

function ICUI_string_into_words(str) {
    var sep=" ",len = 1,i=0,pos;
    var dat = str + sep;
    len = 1;//string_length(sep);
	var arr=[];
    repeat (string_count(sep,dat)) {
        pos = string_pos(sep,dat)-1;
        arr[i]=ICUI_trim(string_lower(string_copy(dat,1,pos)));
        dat = string_delete(dat,1,pos+len);
        i += 1;
    }
    return arr;
}

function ICUI_StringMatchPercentage( haystack, needle, limited ) {
	if ( string_pos(needle,haystack) != 0 ) {
		return array_length(needle)/array_length(haystack) * 100.0;
	}
	var words1=ICUI_string_into_words(haystack);
	var words2=ICUI_string_into_words(needle);
	var len1=array_length(words1);
	var len2=array_length(words2);
	if ( limited == none ) limited=len1;
	if ( limited == -1 ) limited=min(len1,len2);
	var searching=0;
	for ( var i=0; i<len2; i++ ) {
		for ( var j=0; j<len1; j++ ) {
			if ( string_pos(words1[j],words2[i]) != 0 or string_pos(words2[i],words1[j]) != 0 ) searching++;
		}
	}
	return searching / min(limited,len1) * 100.0;
}

function ICUI_DoSearch( device, next ) {
	var start=(next != none ? next : 0);
	if ( __INPUTCANDY.ui.SDLDB_select.search_mode == -1 ) {
		var guid=string_lower(device.guid);
		for ( var i=start; i<global.SDLDB_Entries; i++ ) {
			if ( global.SDLDB[i].guid == guid ) {
				__INPUTCANDY.ui.SDLDB_select.scrolled=i;
				return;
			}
		}
		for ( var i=start; i<global.SDLDB_Entries; i++ ) {
			if ( string_pos(global.SDLDB[i].vid,guid) > 0 and string_pos(global.SDLDB[i].pid,guid) > 0 ) {
				__INPUTCANDY.ui.SDLDB_select.scrolled=i;
				return;
			}
		}
		__INPUTCANDY.ui.SDLDB_select.search_mode=0; // Failed to find GUID
	}
	var deviceName=device.desc;
	if ( start >= global.SDLDB_Entries ) start=0;
	if ( floor(__INPUTCANDY.ui.SDLDB_select.search_mode)%37 == 0 ) {
		var found=start;
		var confidence=0;
		for ( var i=start; i<global.SDLDB_Entries; i++ ) {
			var candidate = ICUI_StringMatchPercentage(global.SDLDB[i].name,deviceName,none);
			if ( candidate > confidence ) {
				found=i;
				confidence=candidate;
			}
		}	
		__INPUTCANDY.ui.SDLDB_select.scrolled=found;
		if ( confidence < 50.0 ) {
			for ( var i=start; i<global.SDLDB_Entries; i++ ) {
				var candidate = ICUI_StringMatchPercentage(global.SDLDB[i].name,deviceName,-1);
				if ( candidate > confidence ) {
					found=i;
					confidence=candidate;
				}
			}
			__INPUTCANDY.ui.SDLDB_select.scrolled=found;
		}
	} else {
		var term=string_lower(ICUI_SDLDB_Search_Character());
		for ( var i=start; i<global.SDLDB_Entries; i++ ) if ( string_pos(term,string_lower(global.SDLDB[i].name)) == 1 ) {
			__INPUTCANDY.ui.SDLDB_select.scrolled=i;
			return;
		}
	}
}

function ICUI_Draw_SDLDB_select() {
	
    // Create new settings if none exist, otherwise let the player choose existing settings or create new.
	if ( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings == none ) {
		if ( __INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device == none ) {
			// Return to previous screen
			     __INPUTCANDY.ui.SDLDB_select.mode=false;
				 __INPUTCANDY.ui.device_select.mode=true;
				return;
		} else {
			var next_profile = array_length(__INPUTCANDY.settings);
			__INPUTCANDY.settings[next_profile]=__ICI.New_ICSettings();
			__INPUTCANDY.settings[next_profile].deviceInfo=__INPUTCANDY.devices[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].device];
			__INPUTCANDY.settings[next_profile].index=next_profile;
			__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings = next_profile;
			__INPUTCANDY.settings[next_profile].deadzone1=gamepad_get_axis_deadzone(__INPUTCANDY.settings[next_profile].deviceInfo.slot_id);
			__INPUTCANDY.settings[next_profile].deadzone2=gamepad_get_button_threshold(__INPUTCANDY.settings[next_profile].deviceInfo.slot_id);
			__ICI.UpdateActiveSetup();			
		} 
	}	
	
    var settings_count=global.SDLDB_Entries;
    var max_menuitem=settings_count+6;  // 0 Back button, 2/3 Up/Down Scroll
	var mi_back=max_menuitem-6;  // Back
	var mi_clear=max_menuitem-5; // Clear mapping
	var mi_next=max_menuitem-3;  // Match By (Same letter / search term)
	var mi_find=max_menuitem-4;  // Find Next
	var mi_top=max_menuitem-2;   // Go to Top of List
	var mi_scrup=max_menuitem-1; // Up
	var mi_scrdn=max_menuitem;   // Down
	if ( __INPUTCANDY.ui.SDLDB_select.influencing < 0 ) {
		__INPUTCANDY.ui.SDLDB_select.influencing=mi_back;
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
	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.SDLDB_select.influencing=mi_back;
	ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_back, "", r.x,r.y,r.w,r.h );
	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Selecting for "+__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.desc+" :: "+__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.guid, ox+__INPUTCANDY.ui.region.w/2, oy );
	ICUI_text( false, "Current Mapping: "+__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.sdl.name+" #"+int(__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo.sdl.index), ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	oy+=smidge+eh*3;

      var buttons_region=rectangle( __INPUTCANDY.ui.region.x+eh, oy-eh, __INPUTCANDY.ui.region.w-(eh*5), eh );
	  
	ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_clear, "Clear Mapping",               buttons_region.x, buttons_region.y, buttons_region.w/4-smidge, buttons_region.h );
	ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_find, "Match By: "+ICUI_SDLDB_Mode(), buttons_region.x+buttons_region.w/4, buttons_region.y, buttons_region.w/4-smidge, buttons_region.h );
	ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_next, "Find Next",                    buttons_region.x+buttons_region.w/2, buttons_region.y, buttons_region.w/4-smidge, buttons_region.h );
	ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_top, "Go to Top",                     buttons_region.x+buttons_region.w/2 + buttons_region.w/4, buttons_region.y, buttons_region.w/4-smidge, buttons_region.h );
	  
	  var lines_region=rectangle(__INPUTCANDY.ui.region.x+eh,oy+smidge,__INPUTCANDY.ui.region.w-(eh*5),__INPUTCANDY.ui.region.y2-oy-eh+smidge/2);
	  var lineh=eh*2;
	  var lineskip=smidge;
	  var lines=floor(lines_region.h / (lineh+lineskip));
	  var sb_region=rectangle(lines_region.x2+eh/2,lines_region.y,eh*2,lines_region.h);
	  var sb_up=rectangle(sb_region.x,sb_region.y,sb_region.w,sb_region.w);
	  var sb_dn=rectangle(sb_region.x,sb_region.y+sb_region.h-sb_up.h,sb_up.w,sb_up.h);
	  var sb_mid=rectangle(sb_up.x,sb_up.y2,sb_region.w,sb_region.h-sb_up.h*2);

	var start_item=__INPUTCANDY.ui.SDLDB_select.scrolled;
	var end_item=min(settings_count-1,start_item+lines-1);

	if ( settings_count > 0 ) {
	    ox=lines_region.x;
		oy=lines_region.y;
		for ( var i=start_item; (i<settings_count) and (i-start_item<lines); i++ ) {
			r=rectangle(ox,oy, lines_region.w-smidge/2, lineh );
			if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.SDLDB_select.influencing=i;
			ICUI_text_in_box(  __INPUTCANDY.ui.SDLDB_select.influencing == i, "SDL #"+int(i+1)+" "+global.SDLDB[i].name+" ::"+global.SDLDB[i].short, r.x,r.y,r.w,r.h );
			oy+=lineh+lineskip;
		}
		if ( cwithin(mouse_x,mouse_y,sb_dn) ) __INPUTCANDY.ui.SDLDB_select.influencing=mi_scrdn;
		ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_scrdn, "", sb_dn.x,sb_dn.y,sb_dn.w,sb_dn.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 3, sb_dn.x, sb_dn.y, sb_dn.w, sb_dn.h, c_white, 0.65, 0, 0.5 );
		if ( cwithin(mouse_x,mouse_y,sb_up) ) __INPUTCANDY.ui.SDLDB_select.influencing=mi_scrup;
		ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_scrup, "", sb_up.x,sb_up.y,sb_up.w,sb_up.h);
		ICUI_fit_image( s_InputCandy_ICUI_icons, 2, sb_up.x, sb_up.y, sb_up.w, sb_up.h, c_white, 0.65, 0, 0.5 );
		ICUI_box(sb_mid.x,sb_mid.y,sb_mid.w,sb_mid.h);
		var first_perc=(__INPUTCANDY.ui.SDLDB_select.scrolled / settings_count);
		var last_perc=min(1.0,(__INPUTCANDY.ui.SDLDB_select.scrolled+lines) / settings_count);
		var total_size=sb_mid.h-smidge*2;
		ICUI_tinted_box(__INPUTCANDY.ui.style.knob1,__INPUTCANDY.ui.style.knob2, sb_mid.x+smidge, sb_mid.y+smidge + total_size*first_perc, sb_mid.w-smidge*2, max(4,(total_size*last_perc)-(total_size*first_perc)) );
	}
	
	if ( __INPUTCANDY.ui.input(ICUI_right) or __INPUTCANDY.ui.input(ICUI_down) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.SDLDB_select.influencing+=1;
		if ( __INPUTCANDY.ui.SDLDB_select.influencing == end_item+1 and end_item < settings_count ) __INPUTCANDY.ui.SDLDB_select.influencing=mi_scrdn;
		if ( __INPUTCANDY.ui.SDLDB_select.influencing > max_menuitem ) {
			__INPUTCANDY.ui.SDLDB_select.influencing=__INPUTCANDY.ui.SDLDB_select.scrolled;
		}
	}
	if ( __INPUTCANDY.ui.input(ICUI_left) or __INPUTCANDY.ui.input(ICUI_up) ) {
		audio_play_sound(a_ICUI_click,100,0);
		__INPUTCANDY.ui.SDLDB_select.influencing-=1;
		if ( __INPUTCANDY.ui.SDLDB_select.influencing < 0 ) __INPUTCANDY.ui.SDLDB_select.influencing=max_menuitem;
		if ( __INPUTCANDY.ui.SDLDB_select.scrolled > 0 and __INPUTCANDY.ui.SDLDB_select.influencing == __INPUTCANDY.ui.SDLDB_select.scrolled-1 ) __INPUTCANDY.ui.SDLDB_select.influencing=mi_scrup;
		if ( __INPUTCANDY.ui.SDLDB_select.influencing == mi_back-1 ) __INPUTCANDY.ui.SDLDB_select.influencing=end_item;
	}
	if( __INPUTCANDY.ui.input(ICUI_button) ) {
	 	audio_play_sound(a_ICUI_tone,100,0);
		switch ( __INPUTCANDY.ui.SDLDB_select.influencing ) {
			case mi_back: // Abort / go back / cancel
			 __INPUTCANDY.ui.SDLDB_select.mode=false;
			 __INPUTCANDY.ui.device_select.mode=true;
			 audio_play_sound(a_ICUI_pageflip,100,0);
			break;
			case mi_top:
			 __INPUTCANDY.ui.SDLDB_select.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_find:
 		 	 __INPUTCANDY.ui.SDLDB_select.search_mode++;
			 if ( __INPUTCANDY.ui.SDLDB_select.search_mode > ICUI_MaxSearchMode() ) __INPUTCANDY.ui.SDLDB_select.search_mode=ICUI_MinSearchMode();
			 ICUI_DoSearch(__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo,none);
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_next:
			 ICUI_DoSearch(__INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing].settings].deviceInfo,__INPUTCANDY.ui.SDLDB_select.scrolled+1);
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_clear: // Clear current mapping
			 {
				var player=__INPUTCANDY.players[__INPUTCANDY.ui.device_select.influencing];
				if ( player.settings != none )	__INPUTCANDY.settings[player.settings].deviceInfo.sdl={ index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" };
				if ( player.device != none ) {
					__INPUTCANDY.devices[player.device].sdl={ index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" };
					gamepad_remove_mapping(__INPUTCANDY.devices[player.device].slot_id);
				}
			 }
			 audio_play_sound(a_ICUI_pageflip,100,0);
			break;
			case mi_scrup: // Scroll up
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled > 0 ) __INPUTCANDY.ui.SDLDB_select.scrolled-=lines;
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled < 0 ) __INPUTCANDY.ui.SDLDB_select.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			case mi_scrdn: // Scroll down
   			 __INPUTCANDY.ui.SDLDB_select.scrolled+=lines-1;
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled >= settings_count - (lines - 1) ) __INPUTCANDY.ui.SDLDB_select.scrolled = settings_count - (lines - 1);
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled < 0 ) __INPUTCANDY.ui.SDLDB_select.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
			break;
			default:
			    __INPUTCANDY.settings[__INPUTCANDY.players[__INPUTCANDY.ui.detect_select.influencing].settings].deviceInfo.sdl=global.SDLDB[__INPUTCANDY.ui.SDLDB_select.influencing];
				__INPUTCANDY.devices[__INPUTCANDY.players[__INPUTCANDY.ui.detect_select.influencing].device].sdl=SDLDB_Lookup_GUID(__INPUTCANDY.devices[i].guid );
				__ICI.ApplySDLMappings();
				audio_play_sound(a_ICUI_tone,100,0);
			break;
		}
	} else {
		if ( mouse_wheel_up() ) {
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled > 0 ) __INPUTCANDY.ui.SDLDB_select.scrolled-=lines;
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled < 0 ) __INPUTCANDY.ui.SDLDB_select.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
        } else if ( mouse_wheel_down() ) {
   			 __INPUTCANDY.ui.SDLDB_select.scrolled+=lines-1;
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled >= settings_count - (lines - 1) ) __INPUTCANDY.ui.SDLDB_select.scrolled = settings_count - (lines - 1);
			 if ( __INPUTCANDY.ui.SDLDB_select.scrolled < 0 ) __INPUTCANDY.ui.SDLDB_select.scrolled=0;
             audio_play_sound(a_ICUI_click,100,0);
		}
	}

	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}

function ICUI_Draw_gamepad_test() {
	
	var player_index=__INPUTCANDY.ui.device_select.influencing;
	var player_number=player_index+1;
	var player=__INPUTCANDY.players[player_index];
	var km=__INPUTCANDY.player_using_keyboard_mouse == player_index and __INPUTCANDY.allow_keyboard_mouse;
	
	var settings_index=player.settings;
	var settings=settings_index == none ? none : __INPUTCANDY.settings[settings_index];
	
	// Someone ripped out the controller?
	if ( player.device > array_length(__INPUTCANDY.devices)-1 or player.device == none and not km ) {  // go back
		__INPUTCANDY.ui.gamepad_test.mode=false;
		__INPUTCANDY.ui.gamepad_test.exitting=false;
		__INPUTCANDY.ui.device_select.mode=true;
		return;
	}	
	
	var device=player.device==none?none:__INPUTCANDY.devices[player.device];
	
	// How many input detected elements to display per line
	var test_wrap=floor( (__INPUTCANDY.ui.region.w*0.75) / 128);
	
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

    var mi_back=1;  // Back

		
	// Draws a background
	ICUI_text_in_box( false, "", __INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, __INPUTCANDY.ui.region.w, __INPUTCANDY.ui.region.h );

	var sx=__INPUTCANDY.ui.region.x;
	var sy=__INPUTCANDY.ui.region.y;

	// Back Button
//	var r=rectangle(__INPUTCANDY.ui.region.x, __INPUTCANDY.ui.region.y, eh*2, eh*2);
//	if ( cwithin(mouse_x,mouse_y,r) ) __INPUTCANDY.ui.SDLDB_select.influencing=mi_back;
//	ICUI_labeled_button( __INPUTCANDY.ui.SDLDB_select.influencing == mi_back, "", r.x,r.y,r.w,r.h );
//	draw_sprite_ext(s_InputCandy_ICUI_icons,0,__INPUTCANDY.ui.region.x+eh,__INPUTCANDY.ui.region.y+eh,icon_scale*eh,icon_scale*eh,0,__INPUTCANDY.ui.style.text1,1.0);

    // Title
	oy+=eh;
	ICUI_text( false, "Testing Player #"+int(player_number)+"  Settings "+(settings==none?"(none)":("#"+int(settings_index+1))), ox+__INPUTCANDY.ui.region.w/2, oy );
	ICUI_text( false, (player.device==none?"":("For "+device.desc))+(km?" with Keyboard and Mouse" : ""), ox+__INPUTCANDY.ui.region.w/2, oy+eh );
	//ICUI_text( false, action.name+(action), ox+__INPUTCANDY.ui.region.w/2, oy+eh*2 );
	var held=ICUI_test_duration_s-__INPUTCANDY.ui.gamepad_test.expired;
	if ( held < 0 )	ICUI_text( false, "Release button to exit",  ox+__INPUTCANDY.ui.region.w/2, oy+eh*2 );
	else ICUI_text( false, "Hold a button for "+int(held)+" seconds to exit",  ox+__INPUTCANDY.ui.region.w/2, oy+eh*2 );
	oy+=smidge+eh*4;
	
	var found=false;
	var r;

    if ( device != none ) {
     var len =array_length(__INPUTCANDY.states[player.device].signals);
	 if ( len > 0 ) found=true;
	 var codes=[];
	 var j=0;
	 for ( i=0; i<len; i++ ) if ( __INPUTCANDY.states[player.device].signals[i].is_held ) {
		 codes[j]=__INPUTCANDY.states[player.device].signals[i].signal_index;
		 j++;
		 if ( j == test_wrap ) {
			r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  			ICUI_draw_ICaction(codes,ICDeviceType_gamepad,false,true,false,r);
			 oy+=smidge+eh*3;
			 codes=[];
			 j=0;
		 }
	 }
	 if ( array_length(codes) > 0 ) {
		 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
		 ICUI_draw_ICaction(codes,ICDeviceType_gamepad,false,true,false,r);
		 oy+=smidge+eh*3;
	 }
	 
	 var state=__INPUTCANDY.states[player.device];
//	 var hat_icon=16;
//	 var axis_icon=17;
	 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/4,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
	 if ( (state.LV != AXIS_NO_VALUE or state.LH != AXIS_NO_VALUE) and ( floor(state.LV*10)/10 != 0 or floor(state.LH*10)/10 != 0 ) ) {
		 ICUI_image( s_InputCandy_ICUI_icons, 17, r.x-__INPUTCANDY.ui.region.w/8, r.y, eh, eh, c_white, 0, 1.0 );
		 ICUI_text( false, "Left Stick, Axes:\nH:"+(state.LH != AXIS_NO_VALUE ? string_format(state.LH,1,1) : "-")+" V:"+(state.LV != AXIS_NO_VALUE ? string_format(state.LV,1,1) : "-"), r.x, r.y );
	 }
	 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/2,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
	 if ( (state.RV != AXIS_NO_VALUE or state.RH != AXIS_NO_VALUE) and ( floor(state.RV*10)/10 != 0 or floor(state.RH*10)/10 != 0 ) ) {
		 ICUI_image( s_InputCandy_ICUI_icons, 17, r.x-__INPUTCANDY.ui.region.w/8, r.y, eh, eh, c_white, 0, 1.0 );
		 ICUI_text( false, "Right Stick, Axes:\nH:"+(state.RH != AXIS_NO_VALUE ? string_format(state.RH,1,1) : "-")+" V:"+(state.RV != AXIS_NO_VALUE ? string_format(state.RV,1,1) : "-"), r.x, r.y );
	 }
	 oy += smidge+eh;
	 
	 var k=0;
	 for ( k=0; k<__INPUTCANDY.devices[player.device].axis_count; k++ ) {
		 var axis_state=__IC.GetAxisSignal(player_number,k);
		 if ( axis_state.values != AXIS_NO_VALUE and abs(axis_state.values) > (settings==none ? axis_state.deadzone : settings.deadzone1) ) {
			r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/3,oy,__INPUTCANDY.ui.region.w*0.25,eh*2);
            ICUI_image( s_InputCandy_ICUI_icons, 17, r.x-__INPUTCANDY.ui.region.w/8, r.y, eh, eh, c_white, 0, 1.0 );
			ICUI_text( false, "Axis #"+int(k)+" = "+string_format(axis_state.values,1,2)+" (Dz:"+string_format((settings==none ? axis_state.deadzone : settings.deadzone1),1,2)+")", r.x, r.y );
			oy += smidge+eh;
		 }
	 }
	 
	 oy += smidge+eh;
	}

	if ( km ) {
	 var len =array_length(__INPUTCANDY.mouseStates);
	 if ( len > 0 ) found=true;
	 var codes=[];
	 var j=0;
	 for ( i=0; i<len; i++ ) if ( __INPUTCANDY.mouseStates[i].is_held ) {
		 codes[j]=__INPUTCANDY.mouseStates[i].signal_index;
		 j++;
		 if ( j == test_wrap ) {
			r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  			ICUI_draw_ICaction(codes,ICDeviceType_mouse,false,true,false,r);
			 oy+=smidge+eh*2;
			 codes=[];
			 j=0;
		 }
	 }
	 if ( array_length(codes) > 0 ) {
		 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
		 ICUI_draw_ICaction(codes,ICDeviceType_mouse,false,true,false,r);
		 oy+=smidge+eh*2;
	 }
	 len =array_length(__INPUTCANDY.keys);
	 if ( len > 0 ) found=true;
	 var codes=[];
	 var j=0;
	 for ( i=0; i<len; i++ ) if ( __INPUTCANDY.keys[i].is_held ) {
		 codes[j]=__INPUTCANDY.keys[i].signal_index;
		 j++;
		 if ( j == test_wrap ) {
			r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
  			ICUI_draw_ICaction(codes,ICDeviceType_keyboard,false,true,false,r);
			 oy+=smidge+eh*2;
			 codes=[];
			 j=0;
		 }
	 }
	 if ( array_length(codes) > 0 ) {
		 r=rectangle(__INPUTCANDY.ui.region.x+__INPUTCANDY.ui.region.w/8,oy,__INPUTCANDY.ui.region.w*0.75,eh*2);
		 ICUI_draw_ICaction(codes,ICDeviceType_keyboard,false,true,false,r);
		 oy+=smidge+eh*2;
	 } 
	}

	if ( found == false ) __INPUTCANDY.ui.gamepad_test.expired=0;
	else __INPUTCANDY.ui.gamepad_test.expired += 1.0/room_speed;
	if ( __INPUTCANDY.ui.gamepad_test.expired > ICUI_test_duration_s ) {
		__INPUTCANDY.ui.gamepad_test.exitting=true;
	}
	if ( __INPUTCANDY.ui.gamepad_test.exitting and found == false ) {  // go back
		__INPUTCANDY.ui.gamepad_test.mode=false;
		__INPUTCANDY.ui.gamepad_test.exitting=false;
		__INPUTCANDY.ui.device_select.mode=true;
	}

	draw_set_font(oldfont);
	draw_set_halign(oldhalign);
	draw_set_valign(oldvalign);
}
