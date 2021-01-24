
if ( IC_Match( player_number, "Jump" ) ) 

if ( IC_Match( player_number, "Shoot" ) ) audio_play_sound(a_ICUI_tone,100,0);

var moving=IC_Match( player_number, "Move" );
if ( moving.up ) {
	y-=1;
}
if ( moving.left ) {
	x-=1;
}
if ( moving.right ) {
	x+=1;
}
if ( moving.down ) {
	y+=1;
}
