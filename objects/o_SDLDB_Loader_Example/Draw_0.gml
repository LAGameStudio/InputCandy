if ( loaded ) {
	draw_sprite_ext(s_SDLDB_Loading_Disc,1,x,y,4.0,4.0,0,c_white,remaining/duration);
	draw_set_halign(fa_center);
	draw_text(x,y+64,"complete");
	draw_set_halign(fa_left);
} else {
	draw_sprite_ext(s_SDLDB_Loading_Disc,0,x,y,4.0,4.0,0,c_white,complete > 0.9 ? (1.0-(complete-0.9)/0.1) : (expired%0.5)*2);
	draw_set_halign(fa_center);
	draw_text(x,y+64,int(complete*100)+"%");
	draw_text(x,y+64+16,int(__INPUTCANDY.SDLDB_Read_Bytes)+" bytes read");
	draw_text(x,y-64,"Loading SDL Gamepad Database");
	draw_set_halign(fa_left);
}