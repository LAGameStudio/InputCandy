
if ( __IC.Match( player_number, _Jump ) ) {
	audio_play_sound(a_ICUI_tone,100,0);
}

if ( __IC.Match( player_number, _Shoot ) ) {
	audio_play_sound(a_ICUI_click,100,0);
}

var moving=__IC.Match( player_number, _Move );

if ( moving == false ) { /* Not moving... */ } else if ( is_struct(moving) ) {
	if ( moving.up ) y-=1;
	if ( moving.left ) x-=1;
	if ( moving.right )	x+=1;
	if ( moving.down ) y+=1;
}
