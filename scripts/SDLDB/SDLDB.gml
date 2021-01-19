#macro __SDLDB_PROCESS_SPLIT_BATCH_SIZE room_speed
#macro __SDLDB_PROCESS_LINES_BATCH_SIZE room_speed
#macro __SDLDB_READ_BYTE_CHUNK_SIZE  1024


// Converts a copy of the SDL_GameControllerDB into an array.  See below for "unwrapped" iterative version that doesn't block user input.
function Process_SDL_GameControllerDB(txt) {
	var sanitized = string_replace_all(txt,"\r","");
	var out=[];
	var lines=string_split(sanitized,"\n");
	var lineslen=array_length(lines);
	var j=0;
	for ( var i=0; i<lineslen; i++ ) {
		var line=lines[i];
		var comma=string_pos(",",line);
		if ( comma == 0 ) continue; // Empty lines / lines with no CSV
		var pound=string_pos("#",line); // Comment detector
		if ( pound != 0 ) line = string_copy(line,0,pound); // Comment Removal
		var parts=string_split(line,",");
		if ( array_length(parts) < 4 ) continue; // Not a CSV with minimum number of columns
		out[j++]={
			index: j,
			guid: string_lower(parts[0]),
			name: string_lower(parts[1]),
			remapping: line,
			platform: string_replace(parts[array_length(parts)-1],"platform:","")
		};
	}
	return out;
}


function SDLDB_Load_Start() {
 __INPUTCANDY.SDLDB_Buffer="";
 if ( !file_exists("SDLDB.txt") ) __INPUTCANDY.SDLDB_Load_Done=true;
 __INPUTCANDY.SDLDB_Load_Done=false;
 __INPUTCANDY.SDLDB_File=file_bin_open("SDLDB.txt",0);
 __INPUTCANDY.SDLDB_Size_Bytes=file_bin_size(__INPUTCANDY.SDLDB_File);
 __INPUTCANDY.SDLDB_Read_Bytes=0;
}

function SDLDB_Load_Step() {
	if ( __INPUTCANDY.SDLDB_Load_Done ) return true;
	if ( file_bin_position(__INPUTCANDY.SDLDB_File) == file_bin_size(__INPUTCANDY.SDLDB_File) ) {
		file_bin_close(__INPUTCANDY.SDLDB_File);
        __INPUTCANDY.SDLDB_Load_Done = true;
		return true;
	}
	
	var i;
	for ( i=0; i<__SDLDB_READ_BYTE_CHUNK_SIZE; i++ ){
		if ( file_bin_position(__INPUTCANDY.SDLDB_File) == file_bin_size(__INPUTCANDY.SDLDB_File) ) break;
		__INPUTCANDY.SDLDB_Buffer += chr(file_bin_read_byte(__INPUTCANDY.SDLDB_File));
	}
    __INPUTCANDY.SDLDB_Read_Bytes+=i;	
	return false;
}


// Converts a copy of the SDL_GameControllerDB into an array.
function SDLDB_Process_Start() {
 global.SDLDB=[];
 __INPUTCANDY.SDLDB_Process_Sanitized=string_replace_all(__INPUTCANDY.SDLDB_Buffer,"\r","")+"\n";
 __INPUTCANDY.SDLDB_Process_Splitlines_Done=false;
 __INPUTCANDY.SDLDB_Process_i=0;
 __INPUTCANDY.SDLDB_Process_len=string_count("\n",__INPUTCANDY.SDLDB_Process_Sanitized);
 __INPUTCANDY.SDLDB_Process_Lines=[];
 __INPUTCANDY.SDLDB_Process_j=0;
 __INPUTCANDY.SDLDB_Process_Completeness=0;
}

function SDLDB_Process_Step() {
	if ( !__INPUTCANDY.SDLDB_Process_Splitlines_Done ) {
		repeat ( __SDLDB_PROCESS_SPLIT_BATCH_SIZE ) {
			__INPUTCANDY.SDLDB_Process_Completeness=(__INPUTCANDY.SDLDB_Process_i/__INPUTCANDY.SDLDB_Process_len) * 0.5;
			var p=string_pos("\n",__INPUTCANDY.SDLDB_Process_Sanitized)-1;
			if ( p >= 0 ) {
			__INPUTCANDY.SDLDB_Process_Lines[__INPUTCANDY.SDLDB_Process_i]=string_copy(__INPUTCANDY.SDLDB_Process_Sanitized,1,p);
			__INPUTCANDY.SDLDB_Process_i++;
			__INPUTCANDY.SDLDB_Process_Sanitized=string_delete(__INPUTCANDY.SDLDB_Process_Sanitized,1,p+1);
			} else {
				__INPUTCANDY.SDLDB_Process_Splitlines_Done=true;
				__INPUTCANDY.SDLDB_Process_i=0;
				__INPUTCANDY.SDLDB_Process_len = array_length(__INPUTCANDY.SDLDB_Process_Lines);
				break;
			}
		}
		return false;
	}
	if ( __INPUTCANDY.SDLDB_Process_i < __INPUTCANDY.SDLDB_Process_len ) {
		repeat ( __SDLDB_PROCESS_LINES_BATCH_SIZE ) {
			var line = __INPUTCANDY.SDLDB_Process_Lines[__INPUTCANDY.SDLDB_Process_i];
			__INPUTCANDY.SDLDB_Process_i++;
			var comma=string_pos(",",line);
			if ( comma == 0 ) { // Empty lines / lines with no CSV
				/* Do nothing */
			} else {
				var pound=string_pos("#",line); // Comment detector
				if ( pound != 0 ) line = string_copy(line,0,pound); // Comment Removal
				var parts=string_split(line,",");
				if ( array_length(parts) < 4 ) { // Not a CSV with minimum number of columns
					/* Do nothing */
				} else {
					global.SDLDB[__INPUTCANDY.SDLDB_Process_j]={
						index: __INPUTCANDY.SDLDB_Process_j,
						guid: string_lower(parts[0]),
						name: string_lower(parts[1]),
						remapping: line,
						platform: string_replace(parts[array_length(parts)-1],"platform:","")
					};
					__INPUTCANDY.SDLDB_Process_j++;
					__INPUTCANDY.SDLDB_Process_Completeness=0.5 + (__INPUTCANDY.SDLDB_Process_i/__INPUTCANDY.SDLDB_Process_len) * 0.5;
				}
			}
		}
		return false;
	}
	global.SDLDB_Entries=array_length(global.SDLDB);
	__INPUTCANDY.SDLDB_Buffer=""; // Saves ram?	
	__INPUTCANDY.SDLDB_Process_Lines=[]; // Saves ram?
	__IC.ParseDeviceGUIDs();
	return true;
}

/// Lookup functions.

function SDLDB_Lookup_GUID( guid ) {
	guid=string_lower(guid);
	for ( var i=0; i<global.SDLDB_Entries; i++ ) if ( global.SDLDB[i].guid == guid ) return global.SDLDB[i];
	return { index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" };
}

function SDLDB_Lookup_Name( name ) {
	name=string_lower(name);
	for ( var i=0; i<global.SDLDB_Entries; i++ ) if ( global.SDLDB[i].name == name ) return global.SDLDB[i];
	return { index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" };
}


function SDLDB_Lookup_Letters( name ) {
	name=string_lower(string_letters(name));
	var results=[];
	for ( var i=0; i<global.SDLDB_Entries; i++ ) if ( string_letters(global.SDLDB[i].name) == name ) return global.SDLDB[i];
	return { index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" };
}

function SDLDB_Lookup_MatchName( name ) {
	name=string_lower(name);
	var results=[];
	for ( var i=0; i<global.SDLDB_Entries; i++ ) if ( string_pos(name,global.SDLDB[i].name) != 0 ) results[array_length(results)]=global.SDLDB[i];
	return results;
}


// Device identification.

function SDLDB_Lookup_Device( device ) {
	var lookup=SDLDB_Lookup_GUID(device);
	if ( lookup.index != -1 ) return lookup;
	lookup=SDLDB_Lookup_Name(device.desc);
	if ( lookup.index != -1 ) return lookup;
	lookup=SDLDB_Lookup_Letters(device.desc);
	if ( lookup.index != -1 ) return lookup;
	var desc_words=string_split(device.desc," ");
	var len=array_length(desc_words);
	for ( var i=0; i<len; i++ ) {
		lookup=SDLDB_Lookup_Letters(desc_words[i]);
		if ( lookup.index != -1 ) return lookup;
	}
	// Nothing found :( ... Let's try to figure it out from the device parameters.
	var response= { index: -1, guid: "none", name: "Unknown", remapping: "", platform: "" };
	if ( device.axis_count == 5 and device.button_count == 17 ) response.name="Retrolink N64-style Classic Controller (Guessed)";
	if ( device.axis_count == 2 and device.button_count == 10 ) response.name="SNES-style Controller (Guessed)";
	if ( __INPUTCANDY.platform.keyboard_mouse_supported and device.axis_count == 4 and device.button_count == 16 ) response.name="XInput Controller (Guessed)";
	if ( string_pos("xinput",string_lower(device.desc)) != 0 )  response.name="XInput Controller (Guessed)";
	return response;
}