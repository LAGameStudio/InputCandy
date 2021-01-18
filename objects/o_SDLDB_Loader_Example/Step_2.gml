expired+=delta;
youve_got_mail = SDLDB_Load_Step();
complete = __INPUTCANDY.SDLDB_Read_Bytes/__INPUTCANDY.SDLDB_Size_Bytes;
if ( !loaded and youve_got_mail ) {
	loaded=true;
	audio_play_sound(a_SDLDB_Load_Complete,100,0);
} else if ( loaded ) {
	remaining-=delta;
	if (remaining < 0.0) room_goto(rm_InputCandySimple_demo);
}