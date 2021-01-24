draw_sprite_ext( sprite_index, 0, x, y, 1, 1, 0, player_tint, 1.0 );

var oldha=draw_get_halign();

draw_set_halign(fa_center);

draw_text( x+16, y+16, "Player "+int(player_number) );

draw_set_halign(oldha);