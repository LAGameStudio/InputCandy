#macro __SDLDB_PROCESS_LINES 10
#macro __SDLDB_READ_BYTE_CHUNK_SIZE  1024


// Converts a copy of the SDL_GameControllerDB into an array.
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
 if ( !file_exists("SDLDB.txt") ) global.SDLDB_Done=true;
 __INPUTCANDY.SDLDB_Done=false;
 __INPUTCANDY.SDLDB_File=file_bin_open("SDLDB.txt",0);
 __INPUTCANDY.SDLDB_Size_Bytes=file_bin_size(__INPUTCANDY.SDLDB_File);
 __INPUTCANDY.SDLDB_Read_Bytes=0;
}

function SDLDB_Load_Step() {
	if ( __INPUTCANDY.SDLDB_Done ) return true;
	if ( file_bin_position(__INPUTCANDY.SDLDB_File) == file_bin_size(__INPUTCANDY.SDLDB_File) ) {
		file_bin_close(__INPUTCANDY.SDLDB_File);
		global.SDLDB=Process_SDL_GameControllerDB( __INPUTCANDY.SDLDB_Buffer );
		global.SDLDB_Entries=array_length(global.SDLDB);
		__IC.ParseDeviceGUIDs();
		__INPUTCANDY.SDLDB_Buffer=""; // Saves ram?
        __INPUTCANDY.SDLDB_Done = true;
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