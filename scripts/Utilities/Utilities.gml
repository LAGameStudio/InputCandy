/* 
   The following functions are required for use by InputCandy.  (Not InputCandySimple)
   They are really useful functions, you should use them too.  (c) 2020 LostAstronaut.com
 */

function cartesian( x1_, y1_, x2_, y2_ ) {
 return {
  x: x1_,
  y: y1_,
  x2: x2_,
  y2: y2_,
  w: max(x1_,x2_)-min(x1_,x2_),
  h: max(y1_,y2_)-min(y1_,y2_),
  distance: point_distance(x1_,y1_,x2_,y2_),
  midx: (x1_+x2_)/2,
  midy: (y1_+y2_)/2,
  angle: point_direction(x1_,y1_,x2_,y2_)
 };
}

function rectangle( x_, y_, w_, h_ ) {
 var x2_=x_+w_;
 var y2_=y_+h_;
 return {
  x: x_,
  y: y_,
  x2: x2_,
  y2: y2_,
  w: w_,
  h: h_,
  distance: point_distance(x_,y_,x2_,y2_),
  midx: (x_+x2_)/2,
  midy: (y_+y2_)/2,
  angle: point_direction(x_,y_,x2_,y2_)
 };	
}

// Get a point on the line at normalized 0-1 ratio (0 = start, 1=end)
function point_on_line( c, time ) {
 return {
  x: c.x+time*(c.x2-c.x),
  y: c.y+time*(c.y2-c.y)
 };
}

// Get a list of points from c.x,c.y to c.x2,c.y2 include endpoints
function points_on_line( c, precision ) {
 var dt=1.0/precision;
 var t=0.0;
 var points;
 var i=0;
 while ( i<=precision ) {
  points[i]=point_on_line( c, t );
  t+=dt;
  i++;
 }  
 return points;
}

// Determine what "time" (normalized 0-1) along line "c" point x_, y_ is
function point_line_time( c, x_, y_ ) {
 return point_distance(c.x,c.y,x_,y_)/c.distance;
}

 // Calculates a perpendicular point at (time) along line (dist) far from line.
function point_line_perpendicular( c, time, distance, deltaAngle_or90 ) {
 var p=point_on_line( c, time );
 var a=deg2rad(c.angle + deltaAngle_or90);
 return {
  x:p.x+distance*cos(v),
  y:p.y+distance*sin(v)
 }; 
}

// Draws a line of a certain thickness containing a certain texture centered around the midpoint of cartesian c
function textured_line( c, middle_center_origin_sprite, subimage, line_tint, line_alpha, line_width ) {
 draw_sprite_ext(
  middle_center_origin_sprite,subimage,c.x,c.y,
  1.0/sprite_get_width(middle_center_origin_sprite)*line_width,
  1.0/sprite_get_height(middle_center_origin_sprite)*c.distance,
  c.angle-90,
  line_tint,
  line_alpha
 );
}

// Similar to the above but will further rotate the line.
function textured_line_angle( c, angle, middle_center_origin_sprite, subimage, line_tint, line_alpha, line_width ) {
 draw_sprite_ext(
  middle_center_origin_sprite,subimage,c.x,c.y,
  1.0/sprite_get_width(middle_center_origin_sprite)*line_width,
  1.0/sprite_get_height(middle_center_origin_sprite)*c.distance,
  angle,
  line_tint,
  line_alpha
 );
}

// Chooses a random bright color.
function choose_bright_rgb() {
	var r=irandom(255);
	var g=irandom(255);
	var b=irandom(255);
	var limit = 12;
	while ( r+g+b < 255 and limit > 0) {
		if ( r < g && r < b ) r= (r+127) % 255;
		else if ( g < r && g < b ) g= (g+127) % 255;
		else if ( b < g && b < b ) b= (b+127) % 255;
		limit--;
	}
	if (  r+g+b < 255 ) return c_orange;
	return make_color_rgb(r,g,b);
}

// Loads a file into a string.
function file_as_string( filename ) {
 var buffer="",fp;
 if ( !file_exists(filename) ) return "";
 fp = file_bin_open(filename, 0);
 while( file_bin_position(fp) != file_bin_size(fp) )
  buffer += chr(file_bin_read_byte(fp));
 file_bin_close(fp);
 return buffer;
}

// Saves a file out as a string.
function string_as_file( filename, output ) {
 var fp=file_text_open_write(filename);
 file_text_write_string(fp,output);
 file_text_close(fp);
}

// Loads a JSON file
function load_json( filename, defaultStruct ) {
 if ( !file_exists(filename) ) return defaultStruct;
 var buffer="";
 fp = file_bin_open(filename, 0);
 while( file_bin_position(fp) != file_bin_size(fp) ) buffer += chr(file_bin_read_byte(fp));
 file_bin_close(fp);
 return json_parse(buffer);	
}

// Saves a struct as JSON
function save_json( filename, dataOut ) {
 return string_as_file( filename, json_stringify(dataOut) );
}

// Random sign positive or negative times a magnitude argument0
function random_posneg(argument0) {
	return random(argument0)*randomsign();
}

// Randomly + or -
function randomsign() {
	if ( random(50000) % 2 == 1 ) return -1;
	else return 1;
}

// A random range m-n, works in the positive case.  Ex rrange(1,5), whereas rrange(-2,2) is -2 to 0
function rrange(m, n) {
	return m+random(n-m);
}

// Here for legacy reasons.  See DikuMUDs.
function number_range(m, n) {
	return m+random(n-m);
}

// Returns a fuzzy number in a range r around a value a, example  fuzzy(50,25) returns numbers 25 to 75
function fuzzy(a, r) {
	return (a+(random(r*2)-r));
}

/// @description  color_fuzzy(r1,r2,g1,g2,b1,b2);
function color_fuzzy(r1, r2, g1, g2, b1, b2) {
	return make_color_rgb(
	 number_range(r1,r2),
	 number_range(g1,g2),
	 number_range(b1,b2)
	);
}

// Multiply color by a scale, where 1.0 is the original value and 0.5 is "half the original color"
function color_mult(color,scale) {
	var r=color_get_red(color) * scale;
	var g=color_get_green(color) * scale;
	var b=color_get_blue(color) * scale;
	if ( r > 255 ) r=255;
	if ( g > 255 ) g=255;
	if ( b > 255 ) b=255;
	return make_color_rgb(r,g,b);
}

// Shorthand to turn a Real into a String
function int(a) { return string_format(a,1,0); }

/*  Usage: arr = string_split(data,sep);
**  Arguments:
**      d        array data, string
**      s         seperator character, string
**  Returns: array
**  Notes: Converts a string of data with elements seperated by a delimiter into an array of strings.
 */
function string_split(d,s) {
    var slen,i,p,out=[];
	d += s;
    slen = string_length(s);
    i = 0;
    repeat (string_count(s,d)) {
        p = string_pos(s,d)-1;
		out[i]=string_copy(d,1,p);
        d = string_delete(d,1,p+slen);
        i += 1;
    }
    return out;
}

// The C/C++ version of A % B with float/decimals.
function fmod(a, b) {
  return (a/b - floor(a/b));
}