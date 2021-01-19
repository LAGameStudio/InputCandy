/*
  GMS_any (can be refactored easily to earlier versions)
  
  InputCandySimple
  
  This is the simplest form with the widest availability.  You can make good games with it,
  but it doesn't take full use of the controller.  Consider this a "NES" controller.
  
 Extend it if you want.  The patterns are already there for more than 8 players, or to attach
 additional button checks.
 
 Lost Astronaut used this control scheme in an easy to pick up game for 8 players called Apolune 2,
 made for the Atari, and made to be super easy to play.  You can add additional support for
 more buttons (most controllers have left/right shoulder and ABXY) but the Atari VCS's "classic joystick"
 only has two buttons, so "A", "B" and "AB".  
  
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
	 - If a user disconnects a controller then reconnects it, it most likely causes reordering.
	 - If a user connects a new controller, it will probably be the last item in the list.
	 
  Usage example:
  
     In your PlayerObject.Create event:
	 
	 controls=InputCandySimple();
	 player_number=1;  // change this to a different number later...
	 
	 In the PlayerObject.Step event:
	
	 if ( controls.left(player_number) ) .... move left or whatever
	 if ( controls.A(player_number) ) ... shoot or whatever
	 
	 
   The functions are:
      controls.left(player_number)
      controls.right(player_number)
      controls.up(player_number)
      controls.down(player_number)
      controls.A(player_number)
      controls.B(player_number)
 
 
  Out-of-the-box it is fairly fast but there is on admitted optimization you can do yourself:
  
  Note that one refactor you may wish to make which provides minor optimization is to remove 
  the following lines from each place they appear other than the "devices" function.
  
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			
 Then, you could simply pass the output of this function to the left() right() etc functions, so
 that this loop would only have to happen once,  Just add a new parameter
 "devices", and refactor the code from there.  
 
 But it's very very fast already and this makes checking things just a little easier, so I've left
 it out for now. 
 
 */

/*
 * Creates the controls object that merges everything as described above.
 */
function InputCandySimple() {
	var control_object = {
		devices: function() {			
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			return {
				gamepads: gamepads,
				count: gamepad_count
			};
		},
		deviceAvailable: function( player_number ) {			
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			return gamepad_count > player_number-1;
		},
		devicesString: function( devices ) {
			var out="Gamepads: \n";
			for ( var i=0; i<devices.count; i++ ) {
				out+="Player "+int(i+1)+" using gamepad Slot #"+int(devices.gamepads[i])+"\n";
			}
			return out;
		},
		left: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  return keyboard_check(vk_left)
				   or keyboard_check(ord("A"))
				   or (0 < gamepad_count and ((gamepad_axis_value(gamepads[0], gp_axislh) < -0.5) or gamepad_button_check(gamepads[0], gp_padl)
					   or (gamepad_hat_count(gamepads[0])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[0])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad4)
				   or keyboard_check(ord("J"))
				   or (1 < gamepad_count and ((gamepad_axis_value(gamepads[1], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[1], gp_padl)
					   or (gamepad_hat_count(gamepads[1])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[1])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 3 ) {
				  return (2 < gamepad_count and ((gamepad_axis_value(gamepads[2], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[2], gp_padl)
					   or (gamepad_hat_count(gamepads[2])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[2])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 4 ) {
				  return (3 < gamepad_count and ((gamepad_axis_value(gamepads[3], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[3], gp_padl)
					   or (gamepad_hat_count(gamepads[3])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[3])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 5 ) {
				  return (4 < gamepad_count and ((gamepad_axis_value(gamepads[4], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[4], gp_padl)
					   or (gamepad_hat_count(gamepads[4])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[4])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 6 ) {
				  return (5 < gamepad_count and ((gamepad_axis_value(gamepads[5], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[5], gp_padl)
					   or (gamepad_hat_count(gamepads[5])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[5])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 7 ) {
				  return (6 < gamepad_count and ((gamepad_axis_value(gamepads[6], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[6], gp_padl)
					   or (gamepad_hat_count(gamepads[6])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[6])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			} else if ( player_number == 8 ) {
				  return (7 < gamepad_count and ((gamepad_axis_value(gamepads[7], gp_axislh) < -0.5)
					   or gamepad_button_check(gamepads[7], gp_padl)
					   or (gamepad_hat_count(gamepads[7])>0 and gamepad_hat_value(gamepads[0],0)&8)
					   or (gamepad_hat_count(gamepads[7])>1 and gamepad_hat_value(gamepads[0],1)&8)));
			}
		},
		right: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  return keyboard_check(vk_right)
				   or keyboard_check(ord("D"))
				   or (0 < gamepad_count and ((gamepad_axis_value(gamepads[0], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[0], gp_padr)
					   or (gamepad_hat_count(gamepads[0])>0 and gamepad_hat_value(gamepads[0],0)&2)
					   or (gamepad_hat_count(gamepads[0])>1 and gamepad_hat_value(gamepads[0],1)&2)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad6)
				   or keyboard_check(ord("L"))
				   or (1 < gamepad_count and ((gamepad_axis_value(gamepads[1], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[1], gp_padr)
					   or (gamepad_hat_count(gamepads[1])>0 and gamepad_hat_value(gamepads[1],0)&2)
					   or (gamepad_hat_count(gamepads[1])>1 and gamepad_hat_value(gamepads[1],1)&2)));
			} else if ( player_number == 3 ) {
				return (2 < gamepad_count and ((gamepad_axis_value(gamepads[2], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[2], gp_padr)
					   or (gamepad_hat_count(gamepads[2])>0 and gamepad_hat_value(gamepads[2],0)&2)
					   or (gamepad_hat_count(gamepads[2])>1 and gamepad_hat_value(gamepads[2],1)&2)));
			} else if ( player_number == 4 ) {
				return (3 < gamepad_count and ((gamepad_axis_value(gamepads[3], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[3], gp_padr)
					   or (gamepad_hat_count(gamepads[3])>0 and gamepad_hat_value(gamepads[3],0)&2)
					   or (gamepad_hat_count(gamepads[3])>1 and gamepad_hat_value(gamepads[3],1)&2)));
			} else if ( player_number == 5 ) {
				return (4 < gamepad_count and ((gamepad_axis_value(gamepads[4], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[4], gp_padr)
					   or (gamepad_hat_count(gamepads[4])>0 and gamepad_hat_value(gamepads[4],0)&2)
					   or (gamepad_hat_count(gamepads[4])>1 and gamepad_hat_value(gamepads[4],1)&2)));
			} else if ( player_number == 6 ) {
				return (5 < gamepad_count and ((gamepad_axis_value(gamepads[5], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[5], gp_padr)
					   or (gamepad_hat_count(gamepads[5])>0 and gamepad_hat_value(gamepads[5],0)&2)
					   or (gamepad_hat_count(gamepads[5])>1 and gamepad_hat_value(gamepads[5],1)&2)));
			} else if ( player_number == 7 ) {
				return (6 < gamepad_count and ((gamepad_axis_value(gamepads[6], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[6], gp_padr)
					   or (gamepad_hat_count(gamepads[6])>0 and gamepad_hat_value(gamepads[6],0)&2)
					   or (gamepad_hat_count(gamepads[6])>1 and gamepad_hat_value(gamepads[6],1)&2)));
			} else if ( player_number == 8 ) {
				return (7 < gamepad_count and ((gamepad_axis_value(gamepads[7], gp_axislh) > 0.5)
					   or gamepad_button_check(gamepads[7], gp_padr)
					   or (gamepad_hat_count(gamepads[7])>0 and gamepad_hat_value(gamepads[7],0)&2)
					   or (gamepad_hat_count(gamepads[7])>1 and gamepad_hat_value(gamepads[7],1)&2)));
			}
		},
		up: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  return keyboard_check(vk_up)
				   or keyboard_check(ord("W"))
				   or (0 < gamepad_count and ((gamepad_axis_value(gamepads[0], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[0], gp_padu)
					   or (gamepad_hat_count(gamepads[0])>0 and gamepad_hat_value(gamepads[0],0)&1)
					   or (gamepad_hat_count(gamepads[0])>1 and gamepad_hat_value(gamepads[0],1)&1)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad8)
				   or keyboard_check(ord("I"))
				   or (1 < gamepad_count and ((gamepad_axis_value(gamepads[1], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[1], gp_padu)
					   or (gamepad_hat_count(gamepads[1])>0 and gamepad_hat_value(gamepads[1],0)&1)
					   or (gamepad_hat_count(gamepads[1])>1 and gamepad_hat_value(gamepads[1],1)&1)));
			} else if ( player_number == 3 ) {
				   return (2 < gamepad_count and ((gamepad_axis_value(gamepads[2], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[2], gp_padu)
					   or (gamepad_hat_count(gamepads[2])>0 and gamepad_hat_value(gamepads[2],0)&1)
					   or (gamepad_hat_count(gamepads[2])>1 and gamepad_hat_value(gamepads[2],1)&1)));
			} else if ( player_number == 4 ) {
				   return (3 < gamepad_count and ((gamepad_axis_value(gamepads[3], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[3], gp_padu)
					   or (gamepad_hat_count(gamepads[3])>0 and gamepad_hat_value(gamepads[3],0)&1)
					   or (gamepad_hat_count(gamepads[3])>1 and gamepad_hat_value(gamepads[3],1)&1)));
			} else if ( player_number == 5 ) {
				   return (4 < gamepad_count and ((gamepad_axis_value(gamepads[4], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[4], gp_padu)
					   or (gamepad_hat_count(gamepads[4])>0 and gamepad_hat_value(gamepads[4],0)&1)
					   or (gamepad_hat_count(gamepads[4])>1 and gamepad_hat_value(gamepads[4],1)&1)));
			} else if ( player_number == 6 ) {
				   return (5 < gamepad_count and ((gamepad_axis_value(gamepads[5], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[5], gp_padu)
					   or (gamepad_hat_count(gamepads[5])>0 and gamepad_hat_value(gamepads[5],0)&1)
					   or (gamepad_hat_count(gamepads[5])>1 and gamepad_hat_value(gamepads[5],1)&1)));
			} else if ( player_number == 7 ) {
				   return (6 < gamepad_count and ((gamepad_axis_value(gamepads[6], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[6], gp_padu)
					   or (gamepad_hat_count(gamepads[6])>0 and gamepad_hat_value(gamepads[6],0)&1)
					   or (gamepad_hat_count(gamepads[6])>1 and gamepad_hat_value(gamepads[6],1)&1)));
			} else if ( player_number == 8 ) {
				   return (7 < gamepad_count and ((gamepad_axis_value(gamepads[7], gp_axislv) > 0.5)
					   or gamepad_button_check(gamepads[7], gp_padu)
					   or (gamepad_hat_count(gamepads[7])>0 and gamepad_hat_value(gamepads[7],0)&1)
					   or (gamepad_hat_count(gamepads[7])>1 and gamepad_hat_value(gamepads[7],1)&1)));
			}
		},
		down: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  return keyboard_check(vk_down)
				   or keyboard_check(ord("S"))
				   or (0 < gamepad_count and ((gamepad_axis_value(gamepads[0], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[0], gp_padd)
					   or (gamepad_hat_count(gamepads[0])>0 and gamepad_hat_value(gamepads[0],0)&4)
					   or (gamepad_hat_count(gamepads[0])>1 and gamepad_hat_value(gamepads[0],1)&4)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_numpad2)
				   or keyboard_check(ord("K"))
				   or (1 < gamepad_count and ((gamepad_axis_value(gamepads[1], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[1], gp_padd)
					   or (gamepad_hat_count(gamepads[1])>0 and gamepad_hat_value(gamepads[1],0)&4)
					   or (gamepad_hat_count(gamepads[1])>1 and gamepad_hat_value(gamepads[1],1)&4)));
			} else if ( player_number == 3 ) {
				   return (2 < gamepad_count and ((gamepad_axis_value(gamepads[2], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[2], gp_padu)
					   or (gamepad_hat_count(gamepads[2])>0 and gamepad_hat_value(gamepads[2],0)&4)
					   or (gamepad_hat_count(gamepads[2])>1 and gamepad_hat_value(gamepads[2],1)&4)));
			} else if ( player_number == 4 ) {
				   return (3 < gamepad_count and ((gamepad_axis_value(gamepads[3], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[3], gp_padu)
					   or (gamepad_hat_count(gamepads[3])>0 and gamepad_hat_value(gamepads[3],0)&4)
					   or (gamepad_hat_count(gamepads[3])>1 and gamepad_hat_value(gamepads[3],1)&4)));
			} else if ( player_number == 5 ) {
				   return (4 < gamepad_count and ((gamepad_axis_value(gamepads[4], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[4], gp_padu)
					   or (gamepad_hat_count(gamepads[4])>0 and gamepad_hat_value(gamepads[4],0)&4)
					   or (gamepad_hat_count(gamepads[4])>1 and gamepad_hat_value(gamepads[4],1)&4)));
			} else if ( player_number == 6 ) {
				   return (5 < gamepad_count and ((gamepad_axis_value(gamepads[5], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[5], gp_padu)
					   or (gamepad_hat_count(gamepads[5])>0 and gamepad_hat_value(gamepads[5],0)&4)
					   or (gamepad_hat_count(gamepads[5])>1 and gamepad_hat_value(gamepads[5],1)&4)));
			} else if ( player_number == 7 ) {
				   return (6 < gamepad_count and ((gamepad_axis_value(gamepads[6], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[6], gp_padu)
					   or (gamepad_hat_count(gamepads[6])>0 and gamepad_hat_value(gamepads[6],0)&4)
					   or (gamepad_hat_count(gamepads[6])>1 and gamepad_hat_value(gamepads[6],1)&4)));
			} else if ( player_number == 8 ) {
				   return (7 < gamepad_count and ((gamepad_axis_value(gamepads[7], gp_axislv) < -0.5)
					   or gamepad_button_check(gamepads[7], gp_padu)
					   or (gamepad_hat_count(gamepads[7])>0 and gamepad_hat_value(gamepads[7],0)&4)
					   or (gamepad_hat_count(gamepads[7])>1 and gamepad_hat_value(gamepads[7],1)&4)));
			}
		},
		A: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  return keyboard_check(vk_lcontrol)
				   or keyboard_check(vk_space)
				   or keyboard_check(vk_lalt)
				   or (0 < gamepad_count
				    and (gamepad_button_check(gamepads[0],gp_face1)
				      or gamepad_button_check(gamepads[0],gp_face3)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_rcontrol)
				   or keyboard_check(vk_ralt)
				   or keyboard_check(vk_pagedown)
				   or keyboard_check(vk_enter)
				   or (1 < gamepad_count
				    and (gamepad_button_check(gamepads[1],gp_face1)
				      or gamepad_button_check(gamepads[1],gp_face3)));
			} else if ( player_number == 3 ) {
				  return (2 < gamepad_count
				    and (gamepad_button_check(gamepads[2],gp_face1)
				      or gamepad_button_check(gamepads[2],gp_face3)));
			} else if ( player_number == 4 ) {
				  return (3 < gamepad_count
				    and (gamepad_button_check(gamepads[3],gp_face1)
				      or gamepad_button_check(gamepads[3],gp_face3)));
			} else if ( player_number == 5 ) {
				  return (4 < gamepad_count
				    and (gamepad_button_check(gamepads[4],gp_face1)
				      or gamepad_button_check(gamepads[4],gp_face3)));
			} else if ( player_number == 6 ) {
				  return (5 < gamepad_count
				    and (gamepad_button_check(gamepads[5],gp_face1)
				      or gamepad_button_check(gamepads[5],gp_face3)));
			} else if ( player_number == 7 ) {
				  return (6 < gamepad_count
				    and (gamepad_button_check(gamepads[6],gp_face1)
				      or gamepad_button_check(gamepads[6],gp_face3)));
			} else if ( player_number == 8 ) {
				  return (7 < gamepad_count
				    and (gamepad_button_check(gamepads[7],gp_face1)
				      or gamepad_button_check(gamepads[7],gp_face3)));
			}
		},
		B: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  return keyboard_check(vk_lshift)
				   or keyboard_check(ord("X"))
				   or keyboard_check(ord("C"))
				   or (0 < gamepad_count
				    and (gamepad_button_check(gamepads[0], gp_face2)
					  or gamepad_button_check(gamepads[0], gp_face4)));
			} else if ( player_number == 2 ) {
				  return keyboard_check(vk_rshift)
				   or keyboard_check(vk_pageup)
				   or keyboard_check(vk_numpad5)
				   or (1 < gamepad_count
				    and (gamepad_button_check(gamepads[1], gp_face2)
					  or gamepad_button_check(gamepads[1], gp_face4)));
			}else if ( player_number == 3 ) {
				  return (2 < gamepad_count
				    and (gamepad_button_check(gamepads[2],gp_face2)
				      or gamepad_button_check(gamepads[2],gp_face4)));
			} else if ( player_number == 4 ) {
				  return (3 < gamepad_count
				    and (gamepad_button_check(gamepads[3],gp_face2)
				      or gamepad_button_check(gamepads[3],gp_face4)));
			} else if ( player_number == 5 ) {
				  return (4 < gamepad_count
				    and (gamepad_button_check(gamepads[4],gp_face2)
				      or gamepad_button_check(gamepads[4],gp_face4)));
			} else if ( player_number == 6 ) {
				  return (5 < gamepad_count
				    and (gamepad_button_check(gamepads[5],gp_face2)
				      or gamepad_button_check(gamepads[5],gp_face4)));
			} else if ( player_number == 7 ) {
				  return (6 < gamepad_count
				    and (gamepad_button_check(gamepads[6],gp_face2)
				      or gamepad_button_check(gamepads[6],gp_face4)));
			} else if ( player_number == 8 ) {
				  return (7 < gamepad_count
				    and (gamepad_button_check(gamepads[7],gp_face2)
				      or gamepad_button_check(gamepads[7],gp_face4)));
			}		
		},
		AB: function ( player_number ) {
			var gamepad_count=gamepad_get_device_count();
			var gamepads=[];
			var j=0;
			for ( var i=0; i<gamepad_count; i++ ) if ( gamepad_is_connected(i) ) gamepads[j++]=i;
			gamepad_count = array_length(gamepads);
			if ( player_number == 1 ) {
				  var a_=keyboard_check(vk_lcontrol)
				   or keyboard_check(vk_space)
				   or keyboard_check(vk_lalt)
				   or (0 < gamepad_count
				    and (gamepad_button_check(gamepads[0],gp_face1)
				      or gamepad_button_check(gamepads[0],gp_face3)));
				  var b_=keyboard_check(vk_lshift)
				   or keyboard_check(ord("X"))
				   or keyboard_check(ord("C"))
				   or (0 < gamepad_count
				    and (gamepad_button_check(gamepads[0], gp_face2)
					  or gamepad_button_check(gamepads[0], gp_face4)));
				 return a_ and b_;
			} else if ( player_number == 2 ) {
				  var a_=keyboard_check(vk_rcontrol)
				   or keyboard_check(vk_ralt)
				   or keyboard_check(vk_pagedown)
				   or keyboard_check(vk_enter)
				   or (1 < gamepad_count
				    and (gamepad_button_check(gamepads[1],gp_face1)
				      or gamepad_button_check(gamepads[1],gp_face3)));
				  var b_=keyboard_check(vk_rshift)
				   or keyboard_check(vk_pageup)
				   or keyboard_check(vk_numpad5)
				   or (1 < gamepad_count
				    and (gamepad_button_check(gamepads[1], gp_face2)
					  or gamepad_button_check(gamepads[1], gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 3 ) {
				  var a_=(2 < gamepad_count
				    and (gamepad_button_check(gamepads[2],gp_face1)
				      or gamepad_button_check(gamepads[2],gp_face3)));
				  var b_=(2 < gamepad_count
				    and (gamepad_button_check(gamepads[2], gp_face2)
					  or gamepad_button_check(gamepads[2], gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 4 ) {
				  var a_=(3 < gamepad_count
				    and (gamepad_button_check(gamepads[3],gp_face1)
				      or gamepad_button_check(gamepads[3],gp_face3)));
				  var b_=(3 < gamepad_count
				    and (gamepad_button_check(gamepads[3], gp_face2)
					  or gamepad_button_check(gamepads[3], gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 5 ) {
				  var a_=(4 < gamepad_count
				    and (gamepad_button_check(gamepads[4],gp_face1)
				      or gamepad_button_check(gamepads[4],gp_face3)));
				  var b_=(4 < gamepad_count
				    and (gamepad_button_check(gamepads[4], gp_face2)
					  or gamepad_button_check(gamepads[4], gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 6 ) {
				  var a_=(5 < gamepad_count
				    and (gamepad_button_check(gamepads[5],gp_face1)
				      or gamepad_button_check(gamepads[5],gp_face3)));
				  var b_=(5 < gamepad_count
				    and (gamepad_button_check(gamepads[5], gp_face2)
					  or gamepad_button_check(gamepads[5], gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 7 ) {
				  var a_=(6 < gamepad_count
				    and (gamepad_button_check(gamepads[6],gp_face1)
				      or gamepad_button_check(gamepads[6],gp_face3)));
				  var b_=(6 < gamepad_count
				    and (gamepad_button_check(gamepads[6], gp_face2)
					  or gamepad_button_check(gamepads[6], gp_face4)));
			     return a_ and b_;
			} else if ( player_number == 8 ) {
				  var a_=(7 < gamepad_count
				    and (gamepad_button_check(gamepads[7],gp_face1)
				      or gamepad_button_check(gamepads[7],gp_face3)));
				  var b_=(7 < gamepad_count
				    and (gamepad_button_check(gamepads[7], gp_face2)
					  or gamepad_button_check(gamepads[7], gp_face4)));
			     return a_ and b_;
			}
		}
	};
    return control_object;
}
