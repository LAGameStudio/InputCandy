/// @description Switch rooms on click

switch ( room ) {
 case rm_InputCandySimple_demo: room_goto(rm_InputCandy_diagnostic_test); break;
 case rm_InputCandy_diagnostic_test: room_goto(rm_InputCandy_device_select); break;
 case rm_InputCandy_device_select: room_goto(rm_InputCandy_control_binding); break;
 case rm_InputCandy_control_binding: room_goto(rm_InputCandy_gamepad_setup); break;
 case rm_InputCandy_gamepad_setup: room_goto(rm_InputCandySimple_demo); break;
}