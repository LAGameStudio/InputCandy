if ( room == rm_InputCandySimple_demo ) draw_text(x+71,y+55,"click logo!");
switch ( room ) {
	case rm_InputCandySimple_demo: draw_text(x+71,y+55,"click logo!");
		break;
	case rm_InputCandy_diagnostic_test: draw_text(x+71,y+55,"Diagnostics");
		break;
	case rm_InputCandy_device_select: draw_text(x+71,y+55,"Device Selection");
		break;
	case rm_InputCandy_control_binding: draw_text(x+71,y+55,"Control Binding");
		break;
	case rm_InputCandy_gamepad_setup: draw_text(x+71,y+55,"Gamepad Setup");
		break;
}