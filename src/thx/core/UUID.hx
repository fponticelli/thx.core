package thx.core;

class UUID {
	static var itoh = '0123456789ABCDEF';

	static inline function random()
		return Math.floor(Math.random()*0x10);

	static inline function srandom()
		return ''+random();

	public static function create() {
		var s = [];
		for(i in 0...8)
			s[i] = srandom();
		s[8]  = '-';
		for(i in 9...13)
			s[i] = srandom();
		s[13] = '-';
		s[14] = '4';
		for(i in 15...18)
			s[i] = srandom();
		s[18] = '-';
		s[19] = '' + ((random() & 0x3) | 0x8);
		for(i in 20...23)
			s[i] = srandom();
		s[23] = '-';
		for(i in 24...36)
			s[i] = srandom();
		return s.join('');
	}
}

/*

  
 
  // Make array of random hex digits. The UUID only has 32 digits in it, but we
  // allocate an extra items to make room for the '-'s we'll be inserting.
  for (var i = 0; i <36; i++) s[i] = Math.floor(Math.random()*0x10)
 
  // Conform to RFC-4122, section 4.4
  s[14] = 4;  // Set 4 high bits of time_high field to version
  s[19] = (s[19] & 0x3) | 0x8  // Specify 2 high bits of clock sequence
 
  // Convert to hex chars
  for (var i = 0; i <36; i++) s[i] = itoh[s[i]]
 
  // Insert '-'s
  s[8] = s[13] = s[18] = s[23] = '-'
 
  return s.join('')

  */