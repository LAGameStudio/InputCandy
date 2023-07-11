image_angle+=0.1;

draw_sprite_ext( sprite_index, 0, x, y, 1, 1, image_angle, player_tint, 1.0 );

var oldha=draw_get_halign();

draw_set_halign(fa_center);

draw_text( x+16, y+16, "Player "+int(player_number) );
if ( moving != false ) {
	draw_text(x+16, y+32, json_stringify(moving));
}


draw_set_halign(oldha);
