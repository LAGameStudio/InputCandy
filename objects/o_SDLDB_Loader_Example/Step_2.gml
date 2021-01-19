expired+=delta;
if ( !loaded ) {
	complete = __INPUTCANDY.SDLDB_Read_Bytes/__INPUTCANDY.SDLDB_Size_Bytes;
	youve_got_mail = SDLDB_Load_Step();
	if ( youve_got_mail ) {
		loaded=true;
		complete=0;
		SDLDB_Process_Start();
	}
} else if ( loaded and !processed ) {
	complete = __INPUTCANDY.SDLDB_Process_Completeness;
	youve_got_mail = SDLDB_Process_Step();
	if ( youve_got_mail ) {
		processed=true;
		audio_play_sound(a_SDLDB_Load_Complete,100,0);
	}
} else {
	remaining-=delta;
	if (remaining < 0.0) room_goto(rm_InputCandySimple_demo);
}