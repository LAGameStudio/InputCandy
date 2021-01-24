/// @description Switch rooms on click

switch ( room ) {
 case rm_InputCandySimple_demo: audio_play_sound(a_ICUI_pageflip,100,0); room_goto(rm_InputCandy_diagnostics); break;
 case rm_InputCandy_diagnostics: audio_play_sound(a_ICUI_pageflip,100,0); room_goto(rm_InputCandy_UI); break;
 case rm_InputCandy_UI: audio_play_sound(a_ICUI_pageflip,100,0); room_goto(rm_InputCandySimple_demo); break;
 case rm_InputCandy_testgame: audio_play_sound(a_ICUI_pageflip,100,0); room_goto(rm_InputCandy_UI); break;
}