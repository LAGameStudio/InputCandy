/*
  GMS_any
  
  InputCandySimple
  
  This is the simplest form with the widest availability.  You can make good games with it,
  but it doesn't take full use of the controller.  Consider this a "NES" controller.
  
  
  Features:
  
	 - Basic controls are Up, Down, Left, Right, A, B
     - Supports up to 8 simultaneous players.  (numbered 1,2,3,4,5,6,7,8)
	 - Control events are "On" or "Not On", no "held for time" detection or anything like that,
	   so you will find yourself using this pattern:
	      if ( controls.A(player_num) and heat == 0 ) { cooldown=heat; heat-=frametime; do_action(); }
	   Use this pattern to avoid firing bullets too often or rejumping every frame
	 - Keyboard (2 Players):
		- maps the "Arrow Keys" and "WASD" to Player 1 as Left/Right/Up/Down, 
	      with Left Ctrl as "A" and Left Shift as "B" -- QWERTY keyboards, right-handed friendly
		- maps the Numpad (Numlock must be on) and/or IJKL to Player 2, where Right Control,
	      Right Shift are "A" and "B" -- ambidextrous friendly, QWERTY keyboards
	 - Mouse: not supported.  Write that into your game yourself using the standard GML functions.
	 - On controllers:
	    - Maps XY to AB
		- Maps LRUD redundantly to provide maximum number of options.
		- Uses a commonly used threshold value to turn axis sticks into dpads
		- Uses the controlled ID as the player ID
		- Can be extended to use Start/Select-or-Back/Shoulders/Triggers, but doesn't support them
	 
  Usage example:
  
     In your PlayerObject.Create event:
	 
	 controls=InputCandySimple();
	 player_number=1;  // change this to a different number later...
	 
	 In the PlayerObject.Step event:
	
	 if ( controls.left(player_number) ) .... move left or whatever
	 if ( controls.A(player_number) ) ... shoot or whatever
	 
	 
 * The functions are:
 *    controls.left(player_number)
 *    controls.right(player_number)
 *    controls.up(player_number)
 *    controls.down(player_number)
 *    controls.A(player_number)
 *    controls.B(player_number)
 */

/*
 * Creates the controls object that merges everything as described above.
 */
function InputCandySimple() {
	var control_object = {
		left: function ( player_number ) {
			for ( var i=0; i<
			if ( player_number == 1 ) {
				  return keyboard_check(vk_left)
				   or keyboard_check(ord("A"))
				   or (gamepad_is_connected(0) 
				    and ((gamepad_axis_value(0, gp_axislh) < -0.5)
					   or gamepad_button_check(0, gp_padl)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad4)
				   or keyboard_check(ord("J"))
				   or (gamepad_is_connected(1) and ((gamepad_axis_value(1, gp_axislh) < -0.5)
					   or gamepad_button_check(1, gp_padl)));
			} else if ( player_number == 3 ) {
				  return (gamepad_is_connected(2) and ((gamepad_axis_value(2, gp_axislh) < -0.5)
					   or gamepad_button_check(2, gp_padl)));
			} else if ( player_number == 4 ) {
				  return (gamepad_is_connected(3) and ((gamepad_axis_value(3, gp_axislh) < -0.5)
					   or gamepad_button_check(3, gp_padl)));
			} else if ( player_number == 5 ) {
				  return (gamepad_is_connected(4) and ((gamepad_axis_value(4, gp_axislh) < -0.5)
					   or gamepad_button_check(4, gp_padl)));
			} else if ( player_number == 6 ) {
				  return (gamepad_is_connected(5) and ((gamepad_axis_value(5, gp_axislh) < -0.5)
					   or gamepad_button_check(5, gp_padl)));
			} else if ( player_number == 7 ) {
				  return (gamepad_is_connected(6) and ((gamepad_axis_value(6, gp_axislh) < -0.5)
					   or gamepad_button_check(6, gp_padl)));
			} else if ( player_number == 8 ) {
				  return (gamepad_is_connected(7) and ((gamepad_axis_value(7, gp_axislh) < -0.5)
					   or gamepad_button_check(7, gp_padl)));
			}
		},
		right: function ( player_number ) {
			if ( player_number == 1 ) {
				  return keyboard_check(vk_right)
				   or keyboard_check(ord("D"))
				   or (gamepad_is_connected(0) and ((gamepad_axis_value(0, gp_axislh) > 0.5)
					   or gamepad_button_check(0, gp_padr)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad6)
				   or keyboard_check(ord("L"))
				   or (gamepad_is_connected(1) and ((gamepad_axis_value(1, gp_axislh) > 0.5)
					   or gamepad_button_check(1, gp_padr)));
			} else if ( player_number == 3 ) {
				return (gamepad_is_connected(2) and ((gamepad_axis_value(2, gp_axislh) > 0.5)
					   or gamepad_button_check(2, gp_padr)));
			} else if ( player_number == 4 ) {
				return (gamepad_is_connected(3) and ((gamepad_axis_value(3, gp_axislh) > 0.5)
					   or gamepad_button_check(3, gp_padr)));
			} else if ( player_number == 5 ) {
				return (gamepad_is_connected(4) and ((gamepad_axis_value(4, gp_axislh) > 0.5)
					   or gamepad_button_check(4, gp_padr)));
			} else if ( player_number == 6 ) {
				return (gamepad_is_connected(5) and ((gamepad_axis_value(5, gp_axislh) > 0.5)
					   or gamepad_button_check(5, gp_padr)));
			} else if ( player_number == 7 ) {
				return (gamepad_is_connected(6) and ((gamepad_axis_value(6, gp_axislh) > 0.5)
					   or gamepad_button_check(6, gp_padr)));
			} else if ( player_number == 8 ) {
				return (gamepad_is_connected(7) and ((gamepad_axis_value(7, gp_axislh) > 0.5)
					   or gamepad_button_check(7, gp_padr)));
			}
		},
		up: function ( player_number ) {
			if ( player_number == 1 ) {
				  return keyboard_check(vk_up)
				   or keyboard_check(ord("W"))
				   or (gamepad_is_connected(0) and ((gamepad_axis_value(0, gp_axislv) > 0.5)
					   or gamepad_button_check(0, gp_padu)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad8)
				   or keyboard_check(ord("I"))
				   or (gamepad_is_connected(1) and ((gamepad_axis_value(1, gp_axislv) > 0.5)
					   or gamepad_button_check(1, gp_padu)));
			} else if ( player_number == 3 ) {
				   return (gamepad_is_connected(2) and ((gamepad_axis_value(2, gp_axislv) > 0.5)
					   or gamepad_button_check(2, gp_padu)));
			} else if ( player_number == 4 ) {
				   return (gamepad_is_connected(3) and ((gamepad_axis_value(3, gp_axislv) > 0.5)
					   or gamepad_button_check(3, gp_padu)));
			} else if ( player_number == 5 ) {
				   return (gamepad_is_connected(4) and ((gamepad_axis_value(4, gp_axislv) > 0.5)
					   or gamepad_button_check(4, gp_padu)));
			} else if ( player_number == 6 ) {
				   return (gamepad_is_connected(5) and ((gamepad_axis_value(5, gp_axislv) > 0.5)
					   or gamepad_button_check(5, gp_padu)));
			} else if ( player_number == 7 ) {
				   return (gamepad_is_connected(6) and ((gamepad_axis_value(6, gp_axislv) > 0.5)
					   or gamepad_button_check(6, gp_padu)));
			} else if ( player_number == 8 ) {
				   return (gamepad_is_connected(7) and ((gamepad_axis_value(7, gp_axislv) > 0.5)
					   or gamepad_button_check(7, gp_padu)));
			}
		},
		down: function ( player_number ) {
			if ( player_number == 1 ) {
				  return keyboard_check(vk_down)
				   or keyboard_check(ord("S"))
				   or (gamepad_is_connected(0) and ((gamepad_axis_value(0, gp_axislv) < -0.5)
					   or gamepad_button_check(0, gp_padd)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad2)
				   or keyboard_check(ord("K"))
				   or (gamepad_is_connected(1) and ((gamepad_axis_value(1, gp_axislv) < -0.5)
					   or gamepad_button_check(1, gp_padd)));
			} else if ( player_number == 3 ) {
				   return (gamepad_is_connected(2) and ((gamepad_axis_value(2, gp_axislv) < -0.5)
					   or gamepad_button_check(2, gp_padu)));
			} else if ( player_number == 4 ) {
				   return (gamepad_is_connected(3) and ((gamepad_axis_value(3, gp_axislv) < -0.5)
					   or gamepad_button_check(3, gp_padu)));
			} else if ( player_number == 5 ) {
				   return (gamepad_is_connected(4) and ((gamepad_axis_value(4, gp_axislv) < -0.5)
					   or gamepad_button_check(4, gp_padu)));
			} else if ( player_number == 6 ) {
				   return (gamepad_is_connected(5) and ((gamepad_axis_value(5, gp_axislv) < -0.5)
					   or gamepad_button_check(5, gp_padu)));
			} else if ( player_number == 7 ) {
				   return (gamepad_is_connected(6) and ((gamepad_axis_value(6, gp_axislv) < -0.5)
					   or gamepad_button_check(6, gp_padu)));
			} else if ( player_number == 8 ) {
				   return (gamepad_is_connected(7) and ((gamepad_axis_value(7, gp_axislv) < -0.5)
					   or gamepad_button_check(7, gp_padu)));
			}
		},
		A: function ( player_number ) {
			if ( player_number == 1 ) {
				  return keyboard_check(vk_lcontrol)
				   or keyboard_check(vk_space)
				   or keyboard_check(vk_lalt)
				   or (gamepad_is_connected(0)
				    and (gamepad_button_check(0,gp_face1)
				      or gamepad_button_check(0,gp_face3)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_rcontrol)
				   or keyboard_check(vk_ralt)
				   or keyboard_check(vk_pagedown)
				   or keyboard_check(vk_enter)
				   or (gamepad_is_connected(1)
				    and (gamepad_button_check(1,gp_face1)
				      or gamepad_button_check(1,gp_face3)));
			} else if ( player_number == 3 ) {
				  return (gamepad_is_connected(2)
				    and (gamepad_button_check(2,gp_face1)
				      or gamepad_button_check(2,gp_face3)));
			} else if ( player_number == 4 ) {
				  return (gamepad_is_connected(3)
				    and (gamepad_button_check(3,gp_face1)
				      or gamepad_button_check(3,gp_face3)));
			} else if ( player_number == 5 ) {
				  return (gamepad_is_connected(4)
				    and (gamepad_button_check(4,gp_face1)
				      or gamepad_button_check(4,gp_face3)));
			} else if ( player_number == 6 ) {
				  return (gamepad_is_connected(5)
				    and (gamepad_button_check(5,gp_face1)
				      or gamepad_button_check(5,gp_face3)));
			} else if ( player_number == 7 ) {
				  return (gamepad_is_connected(6)
				    and (gamepad_button_check(6,gp_face1)
				      or gamepad_button_check(6,gp_face3)));
			} else if ( player_number == 8 ) {
				  return (gamepad_is_connected(7)
				    and (gamepad_button_check(7,gp_face1)
				      or gamepad_button_check(7,gp_face3)));
			}
		},
		B: function ( player_number ) {
			if ( player_number == 1 ) {
				  return keyboard_check(vk_lshift)
				   or keyboard_check(ord("X"))
				   or keyboard_check(ord("C"))
				   or (gamepad_is_connected(0)
				    and (gamepad_button_check(0, gp_face2)
					  or gamepad_button_check(0, gp_face4)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_rshift)
				   or keyboard_check(vk_pageup)
				   or keyboard_check(vk_numpad5)
				   or (gamepad_is_connected(1)
				    and (gamepad_button_check(1, gp_face2)
					  or gamepad_button_check(1, gp_face4)));
			}else if ( player_number == 3 ) {
				  return (gamepad_is_connected(2)
				    and (gamepad_button_check(2,gp_face2)
				      or gamepad_button_check(2,gp_face4)));
			} else if ( player_number == 4 ) {
				  return (gamepad_is_connected(3)
				    and (gamepad_button_check(3,gp_face2)
				      or gamepad_button_check(3,gp_face4)));
			} else if ( player_number == 5 ) {
				  return (gamepad_is_connected(4)
				    and (gamepad_button_check(4,gp_face2)
				      or gamepad_button_check(4,gp_face4)));
			} else if ( player_number == 6 ) {
				  return (gamepad_is_connected(5)
				    and (gamepad_button_check(5,gp_face2)
				      or gamepad_button_check(5,gp_face4)));
			} else if ( player_number == 7 ) {
				  return (gamepad_is_connected(6)
				    and (gamepad_button_check(6,gp_face2)
				      or gamepad_button_check(6,gp_face4)));
			} else if ( player_number == 8 ) {
				  return (gamepad_is_connected(7)
				    and (gamepad_button_check(7,gp_face2)
				      or gamepad_button_check(7,gp_face4)));
			}		
		},
		AB: function ( player_number ) {			
			if ( player_number == 1 ) {
				  var a_=keyboard_check(vk_lcontrol)
				   or keyboard_check(vk_space)
				   or keyboard_check(vk_lalt)
				   or (gamepad_is_connected(0)
				    and (gamepad_button_check(0,gp_face1)
				      or gamepad_button_check(0,gp_face3)));
				  var b_=keyboard_check(vk_lshift)
				   or keyboard_check(ord("X"))
				   or keyboard_check(ord("C"))
				   or (gamepad_is_connected(0)
				    and (gamepad_button_check(0, gp_face2)
					  or gamepad_button_check(0, gp_face4)));
				 return a_ and b_;
			} else if ( player_number == 2 ) {
				  var a_=keyboard_check(vk_rcontrol)
				   or keyboard_check(vk_ralt)
				   or keyboard_check(vk_pagedown)
				   or keyboard_check(vk_enter)
				   or (gamepad_is_connected(1)
				    and (gamepad_button_check(1,gp_face1)
				      or gamepad_button_check(1,gp_face3)));
				  var b_=keyboard_check(vk_rshift)
				   or keyboard_check(vk_pageup)
				   or keyboard_check(vk_numpad5)
				   or (gamepad_is_connected(1)
				    and (gamepad_button_check(1, gp_face2)
					  or gamepad_button_check(1, gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 3 ) {
				  var a_=(gamepad_is_connected(2)
				    and (gamepad_button_check(2,gp_face1)
				      or gamepad_button_check(2,gp_face3)));
				  var b_=(gamepad_is_connected(2)
				    and (gamepad_button_check(2, gp_face2)
					  or gamepad_button_check(2, gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 4 ) {
				  var a_=(gamepad_is_connected(3)
				    and (gamepad_button_check(3,gp_face1)
				      or gamepad_button_check(3,gp_face3)));
				  var b_=(gamepad_is_connected(3)
				    and (gamepad_button_check(3, gp_face2)
					  or gamepad_button_check(3, gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 5 ) {
				  var a_=(gamepad_is_connected(4)
				    and (gamepad_button_check(4,gp_face1)
				      or gamepad_button_check(4,gp_face3)));
				  var b_=(gamepad_is_connected(4)
				    and (gamepad_button_check(4, gp_face2)
					  or gamepad_button_check(4, gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 6 ) {
				  var a_=(gamepad_is_connected(5)
				    and (gamepad_button_check(5,gp_face1)
				      or gamepad_button_check(5,gp_face3)));
				  var b_=(gamepad_is_connected(5)
				    and (gamepad_button_check(5, gp_face2)
					  or gamepad_button_check(5, gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 7 ) {
				  var a_=(gamepad_is_connected(6)
				    and (gamepad_button_check(6,gp_face1)
				      or gamepad_button_check(6,gp_face3)));
				  var b_=(gamepad_is_connected(6)
				    and (gamepad_button_check(6, gp_face2)
					  or gamepad_button_check(6, gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 8 ) {
				  var a_=(gamepad_is_connected(7)
				    and (gamepad_button_check(7,gp_face1)
				      or gamepad_button_check(7,gp_face3)));
				  var b_=(gamepad_is_connected(7)
				    and (gamepad_button_check(7, gp_face2)
					  or gamepad_button_check(7, gp_face4)));
			     return a_ and b_;
			}
		}
	};
    return control_object;
}
