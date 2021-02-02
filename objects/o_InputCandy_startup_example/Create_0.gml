Init_InputCandy_Advanced();


// Setup actions for our test game

__IC.Action( "Jump", IC_B, IC_space, IC_mouse_right );
__IC.Action( "Shoot", IC_A, [ IC_any_control, IC_lctrl, IC_rctrl ], IC_mouse_left );
IC_Action_ext( "Move", "None", IC_dpad, false, IC_arrows, false, IC_none, false, false, true, false, 0, 0, false, true, false );

// Create a bunch of actions to fill the UI -- never checked in the test game


__IC.Action( "Block", IC_X, [ IC_any_alt, IC_lalt, IC_ralt ], IC_mouse_right );
__IC.Action( "Duck",  IC_Y, IC_key_X );
__IC.Action( "Dodge Left", IC_hat0_L, IC_key_A, IC_none );
__IC.Action( "Dodge Right", IC_hat0_R, IC_key_D, IC_none );
__IC.Action( "Dodge High", IC_hat0_U, IC_key_W, IC_none );
__IC.Action( "Dodge Low", IC_hat0_D, IC_key_S, IC_none );
__IC.Action( "Special", IC_Ltrigger, IC_key_E, IC_none );
__IC.Action( "Inventory", IC_Rshoulder, IC_key_I, IC_none );
__IC.Action( "Help/Menu",  IC_back_select, IC_f1, IC_none );
