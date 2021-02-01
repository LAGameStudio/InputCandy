Init_InputCandy_Advanced();


// Setup actions for our test game

__IC.Action( "Jump", IC_B, IC_space, IC_mouse_right );
__IC.Action( "Shoot", IC_A, [ IC_any_control, IC_lctrl, IC_rctrl ], IC_mouse_left );
IC_Action_ext( "Move", "None", IC_dpad, false, IC_arrows, false, IC_none, false, false, true, false, 0, 0, false, true, false );

