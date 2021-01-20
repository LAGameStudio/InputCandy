/// @description Switch rooms on click

switch ( room ) {
 case rm_InputCandySimple_demo: room_goto(rm_InputCandy_diagnostics); break;
 case rm_InputCandy_diagnostics: room_goto(rm_InputCandy_UI); break;
 case rm_InputCandy_UI: room_goto(rm_InputCandySimple_demo); break;
}