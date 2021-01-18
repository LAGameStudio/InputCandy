/// @description Switch rooms on click

switch ( room ) {
 case rm_InputCandy_diagnostic_test: room_goto(rm_InputCandySimple_demo); break;
 case rm_InputCandySimple_demo: room_goto(rm_InputCandy_diagnostic_test); break;
}