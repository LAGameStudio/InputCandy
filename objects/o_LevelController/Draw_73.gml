
for ( var i=0; i<__INPUTCANDY.max_players; i++ ) {
 if ( __INPUTCANDY.players[i].active ) {
	 var str="Player "+int(i+1)+": "+int(__INPUTCANDY.players[i].data.scored)
	  + __IC.PlayerDiagnosticString(i+1);
	 draw_text( 16, (i+1)*64, str );
 } else if ( i == 0 or __INPUTCANDY.players[i].device != none ) {
	 draw_text( 16, (i+1)*64, "Player "+int(i+1)+" press Jump" );
	 if ( __IC.Match(i+1,_Jump) ) {
		 __INPUTCANDY.players[i].active=true;
		 var p = instance_create_layer(room_width/2,room_height/2,"Instances",o_Player);
		 p.player_number=i+1;
		 p.player_index=i;
		 p.player_tint=player_colors[i];
		 __INPUTCANDY.players[i].data=p.id;
	 }
 }
}

/* draw actions
draw_text( room_width-room_width/3, 16,
 string_replace_all(json_stringify(__INPUTCANDY.actions),",",",\n")
);
*/

draw_text( 16, room_height/4+room_height/2, "Keyboard/mouse: \n"+__IC.KeyboardMouseDiagnosticString());