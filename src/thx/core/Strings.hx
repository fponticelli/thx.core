package thx.core;

using StringTools;

class Strings {
	static var _reSplitWC = ~/(\r\n|\n\r|\n|\r)/g;
	static var _reReduceWS = ~/\s+/;
#if !php
	static var _reStripTags = ~/(<[a-z]+[^>\/]*\/?>|<\/[a-z]+>)/i;
#end
// TODO, test me
	public static function upTo(value : String, searchFor : String) {
		var pos = value.indexOf(searchFor);
		if (pos < 0)
			return value;
		else
			return value.substr(0, pos);
	}

	// TODO, test me
	public static function startFrom(value : String, searchFor : String) {
		var pos = value.indexOf(searchFor);
		if (pos < 0)
			return value;
		else
			return value.substr(pos + searchFor.length);
	}

	// TODO, test me
	public static function rtrim(value : String, charlist : String) : String {
#if php
		return untyped __call__("rtrim", value, charlist);
#else
		var len = value.length;
		while (len > 0) {
			var c = value.substr(len - 1, 1);
			if (charlist.indexOf(c) < 0)
				break;
			len--;
		}
		return value.substr(0, len);
#end
	}

	// TODO, test me
	public static function ltrim(value : String, charlist : String) : String {
#if php
		return untyped __call__("ltrim", value, charlist);
#else
		var start = 0;
		while (start < value.length) {
			var c = value.substr(start, 1);
			if (charlist.indexOf(c) < 0)
				break;
			start++;
		}
		return value.substr(start);
#end
	}

	public static inline function trim(value : String, charlist : String) : String {
#if php
		return untyped __call__("trim", value, charlist);
#else
		return rtrim(ltrim(value, charlist), charlist);
#end
	}

	static var _reCollapse = ~/\s+/g;
	public static function collapse(value : String)
		return _reCollapse.replace(StringTools.trim(value), " ");

	public static inline function ucfirst(value : String) : String
		return (value == null ? null : value.charAt(0).toUpperCase() + value.substr(1));

	public static inline function lcfirst(value : String) : String
		return (value == null ? null : value.charAt(0).toLowerCase() + value.substr(1));

	public static function empty(value : String)
		return value == null || value == '';

	public static inline function isAlphaNum(value : String) : Bool
#if php
		return untyped __call__("ctype_alnum", value);
#else
		return (value == null ? false : __alphaNumPattern.match(value));
#end

	public static inline function digitsOnly(value : String) : Bool
#if php
		return untyped __call__("ctype_digit", value);
#else
		return (value == null ? false : __digitsPattern.match(value));
#end

	public static function ucwords(value : String) : String
		return __ucwordsPattern.map(ucfirst(value), __upperMatch);

	/**
	 * Like ucwords but uses only white spaces as boundaries
	 * @param	value
	 * @return
	 */
	public static function ucwordsws(value : String) : String
#if php
		return untyped __call__("ucwords", value);
#else
		return __ucwordswsPattern.map(ucfirst(value), __upperMatch);
#end

	static function __upperMatch(re : EReg)
		return re.matched(0).toUpperCase();
	static var __ucwordsPattern = new EReg('[^a-zA-Z]([a-z])', 'g');
#if !php
	static var __ucwordswsPattern = new EReg('\\s[a-z]', 'g');
	static var __alphaNumPattern = new EReg('^[a-z0-9]+$', 'i');
	static var __digitsPattern = new EReg('^[0-9]+$', '');
#end

	/**
	*  Replaces undescores with space, finds UC characters, turns them into LC and prepends them with a space.
	*  More than one UC in sequence is left untouched.
	**/
	public static function humanize(s : String)
		return underscore(s).replace('_', ' ');

	// TO TEST
	public static function capitalize(s : String)
		return s.substr(0, 1).toUpperCase() + s.substr(1);

	// TO TEST
	public static function succ(s : String)
		return s.substr(0, -1) + String.fromCharCode(s.substr(-1).charCodeAt(0)+1);

	// TO TEST
	public static function underscore(s : String) {
		s = (~/::/g).replace(s, '/');
		s =	(~/([A-Z]+)([A-Z][a-z])/g).replace(s, '$1_$2');
		s = (~/([a-z\d])([A-Z])/g).replace(s, '$1_$2');
		s = (~/-/g).replace(s, '_');
		return s.toLowerCase();
	}

	public static function dasherize(s : String)
		return s.replace('_', '-');

	public static function repeat(s : String, times : Int) {
		var b = [];
		for(i in 0...times)
			b.push(s);
		return b.join('');
	}

	public static function wrapColumns(s : String, columns = 78, indent = "", newline = "\n") {
		var parts = _reSplitWC.split(s);
		var result = [];
		for(part in parts)
		{
			result.push(_wrapColumns(StringTools.trim(_reReduceWS.replace(part, " ")), columns, indent, newline));
		}
		return result.join(newline);
	}

	static function _wrapColumns(s : String, columns : Int, indent : String, newline : String) {
		var parts = [];
		var pos = 0;
		var len = s.length;
		var ilen = indent.length;
		columns -= ilen;
		while(true) {
			if(pos + columns >= len - ilen) {
				parts.push(s.substr(pos));
				break;
			}

			var i = 0;
			while(!StringTools.isSpace(s, pos + columns - i) && i < columns) {
				i++;
			}
			if(i == columns) {
				// search ahead
				i = 0;
				while(!StringTools.isSpace(s, pos + columns + i) && pos + columns + i < len)
				{
					i++;
				}
				parts.push(s.substr(pos, columns + i));
				pos += columns + i + 1;
			} else {
				parts.push(s.substr(pos, columns - i));
				pos += columns - i + 1;
			}
		}

		return indent + parts.join(newline + indent);
	}

	public static function stripTags(s : String) : String
#if php
		return untyped __call__("strip_tags", s);
#else
		return _reStripTags.replace(s, "");
#end

	public static function ellipsis(s : String, maxlen = 20, symbol = "...") {
		if (s.length > maxlen)
			return s.substr(0, symbol.length > maxlen - symbol.length ? symbol.length : maxlen - symbol.length) + symbol;
		else
			return s;
	}

	public static function compare(a : String, b : String) return a < b ? -1 : a > b ? 1 : 0;
}