devices = controls.devices();

stateString="";

for ( var i=0; i<devices.count; i++ ) {
	var pnum=i+1;
	if ( controls.left(pnum) ) stateString+="Player "+int(pnum)+" is pressing left\n";
	if ( controls.right(pnum) ) stateString+="Player "+int(pnum)+" is pressing right\n";
	if ( controls.up(pnum) ) stateString+="Player "+int(pnum)+" is pressing up\n";
	if ( controls.down(pnum) ) stateString+="Player "+int(pnum)+" is pressing down\n";
	if ( controls.AB(pnum) ) stateString+="Player "+int(pnum)+" is pressing both A and B\n";
	else {
		if ( controls.A(pnum) ) stateString+="Player "+int(pnum)+" is pressing A\n";
	    if ( controls.B(pnum) ) stateString+="Player "+int(pnum)+" is pressing B\n";
	}
}