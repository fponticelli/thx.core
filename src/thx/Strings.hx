package thx;

using StringTools;
using thx.Arrays;
import thx.Monoid;

/** Alias of `StringTools`, included so mixins work with `using thx.Strings;` **/
typedef HaxeStringTools = StringTools;

/**
Extension methods for strings.
**/
class Strings {
/**
`after` searches for the first occurrance of `searchFor` and returns the text after that.

If `searchFor` is not found, an empty string is returned.
**/
  public static function after(value : String, searchFor : String) {
    var pos = value.indexOf(searchFor);
    if (pos < 0)
      return "";
    else
      return value.substring(pos + searchFor.length);
  }

  /**
  `afterLast` searches for the last occurrance of `searchFor` and returns the text after that.

  If `searchFor` is not found, an empty string is returned.
  **/
    public static function afterLast(value : String, searchFor : String) {
      var pos = value.lastIndexOf(searchFor);
      if (pos < 0)
        return "";
      else
        return value.substring(pos + searchFor.length);
    }

/**
`before` searches for the first occurrance of `searchFor` and returns the text before that.

If `searchFor` is not found, an empty string is returned.
**/
  public static function before(value : String, searchFor : String) {
    var pos = value.indexOf(searchFor);
    if (pos < 0)
      return "";
    else
      return value.substring(0, pos);
  }

  /**
  `beforeLast` searches for the last occurrance of `searchFor` and returns the text before that.

  If `searchFor` is not found, an empty string is returned.
  **/
    public static function beforeLast(value : String, searchFor : String) {
      var pos = value.lastIndexOf(searchFor);
      if (pos < 0)
        return "";
      else
        return value.substring(0, pos);
    }

/**
`capitalize` returns a string with the first character convert to upper case.
**/
  inline public static function capitalize(s : String) {
    // var s = new UnicodeString(s);
    return s.substr(0, 1).toUpperCase() + s.substr(1);
  }

/**
Capitalize the first letter of every word in `value`. If `whiteSpaceOnly` is set to `true`
the process is limited to whitespace separated words.
**/
  public static function capitalizeWords(value : String, ?whiteSpaceOnly = false) : String {
    if(whiteSpaceOnly) {
    #if (php && haxe_ver>=4.0)
    return php.Global.ucwords(value);
#elseif (php && haxe_ver<4.0)
      return untyped __call__("ucwords", value);
#else
      return UCWORDSWS.map(capitalize(value), upperMatch);
#end
    } else {
      return UCWORDS.map(capitalize(value), upperMatch);
    }
  }

/**
Replaces occurrances of `\r\n`, `\n\r`, `\r` with `\n`;
**/
  public static function canonicalizeNewlines(value : String) : String
    return CANONICALIZE_LINES.replace(value, "\n");

/**
Compares two strings ignoring their case.
**/
  public static function caseInsensitiveCompare(a : String, b : String) : Int {
    if(null == a && null == b)
      return 0;
    if(null == a)
      return -1;
    else if(null == b)
      return 1;
    return compare(a.toLowerCase(), b.toLowerCase());
  }

/**
Returns true if `s` ends with `end` ignoring their case.
**/
  inline public static function caseInsensitiveEndsWith(s : String, end : String) : Bool
    return StringTools.endsWith(s.toLowerCase(), end.toLowerCase());

/**
Compares a string `s` with many `values` and see if one of them matches its end ignoring their case.
**/
  inline public static function caseInsensitiveEndsWithAny(s : String, values : Array<String>) : Bool
    return endsWithAny(s.toLowerCase(), values.map(function(v) return v.toLowerCase()));

/**
Compares two strings ignoring their case.
**/
  inline public static function caseInsensitiveStartsWith(s : String, start : String) : Bool
    return StringTools.startsWith(s.toLowerCase(), start.toLowerCase());

/**
Compares a string `s` with many `values` and see if one of them matches its beginning ignoring their case.
**/
  inline public static function caseInsensitiveStartsWithAny(s : String, values : Array<String>) : Bool
    return startsWithAny(s.toLowerCase(), values.map(function(v) return v.toLowerCase()));

/**
It cleans up all the whitespaces in the passed `value`. `collapse` does the following:

  - remove trailing/leading whitespaces
  - within the string, it collapses seqeunces of whitespaces into a single space character

For whitespaces in this description, it is intended to be anything that is matched by the regular expression `\s`.
**/
  public static function collapse(value : String)
    return WSG.replace(StringTools.trim(value), " ");

/**
It compares to string and it returns a negative number if `a` is inferior to `b`, zero if they are the same,
or otherwise a positive non-sero number.
**/
  public inline static function compare(a : String, b : String)
    return a < b ? -1 : (a > b ? 1 : 0);

  public static var order(default, never): Ord<String> = Ord.fromIntComparison(compare);

/**
`contains` returns `true` if `s` contains one or more occurrences of `test` regardless of the text case.
**/
  inline public static function caseInsensitiveContains(s : String, test : String)
  #if php
    return test == "" || s.toLowerCase().indexOf(test.toLowerCase()) >= 0;
  #else
    return s.toLowerCase().indexOf(test.toLowerCase()) >= 0;
  #end

/**
`contains` returns `true` if `s` contains one or more occurrences of `test`.
**/
  inline public static function contains(s : String, test : String)
  #if php
    return test == "" || s.indexOf(test) >= 0;
  #else
    return s.indexOf(test) >= 0;
  #end

/**
Return the number of occurances of `test` in `s`.
**/
  public static function count(s : String, test : String)
    return s.split(test).length - 1;

/**
`contains` returns `true` if `s` contains any of the strings in `tests` regardless of the text case
**/
  inline public static function caseInsensitiveContainsAny(s : String, tests : Array<String>)
    return tests.any(caseInsensitiveContains.bind(s, _));

/**
`contains` returns `true` if `s` contains any of the strings in `tests`
**/
  inline public static function containsAny(s : String, tests : Array<String>)
    return tests.any(contains.bind(s, _));

/**
`contains` returns `true` if `s` contains all of the strings in `tests` regardless of the text case
**/
  inline public static function caseInsensitiveContainsAll(s : String, tests : Array<String>)
    return tests.all(caseInsensitiveContains.bind(s, _));

/**
`contains` returns `true` if `s` contains all of the strings in `tests`
**/
  inline public static function containsAll(s : String, tests : Array<String>)
    return tests.all(contains.bind(s, _));


/**
`dasherize` replaces all the occurrances of `_` with `-`;
**/
  public static function dasherize(s : String)
    return s.replace('_', '-');

/**
Compares strings `a` and `b` and returns the position where they differ.

```haxe
Strings.diffAt("abcdef", "abc123"); // returns 3
```
**/
  public static function diffAt(a : String, b : String) {
    var min = Ints.min(a.length, b.length);
    for(i in 0...min)
      if(a.substring(i, i+1) != b.substring(i, i+1))
        return i;
    return min;
  }

/**
`ellipsis` truncates `s` at len `maxlen` replaces the last characters with the content
of `symbol`.

```haxe
'thx is a nice library'.ellipsis(8); // returns 'thx is …'
```
**/
  public static function ellipsis(s : String, ?maxlen = 20, ?symbol = "…") {
    // var s = new UnicodeString(s),
    //     symbol = new UnicodeString(symbol);
    var sl = s.length,
        symboll = symbol.length;
    if (sl > maxlen) {
      if(maxlen < symboll) {
        return symbol.substr(symboll - maxlen, maxlen);
      } else {
        return s.substr(0, maxlen - symboll) + symbol;
      }
    } else
      return s;
  }

/**
Same as `ellipsis` but puts the symbol in the middle of the string and not to the end.

```haxe
'thx is a nice library'.ellipsisMiddle(16); // returns 'thx is … library'
```
**/
  public static function ellipsisMiddle(s : String, ?maxlen = 20, ?symbol = "…") {
    // var s = new UnicodeString(s),
    //     symbol = new UnicodeString(symbol);
    var sl = s.length,
        symboll = symbol.length;
    if (sl > maxlen) {
      if(maxlen <= symboll) {
        return ellipsis(s, maxlen, symbol);
      }
      var hll = Math.ceil((maxlen - symboll) / 2),
          hlr = Math.floor((maxlen - symboll) / 2);
      return s.substr(0, hll) + symbol + s.substr(sl - hlr, hlr);
    } else
      return s;
  }

/**
Returns `true` if `s` ends with any of the values in `values`.
**/
  public static function endsWithAny(s : String, values : Iterable<String>) : Bool
    return Iterables.any(values, function(end) return s.endsWith(end));

/**
`filter` applies `predicate` character by character to `s` and it returns a filtered
version of the string.
**/
  public static function filter(s : String, predicate : String -> Bool)
    return toArray(s)
      .filter(predicate)
      .join('');

/**
Same as `filter` but `predicate` operates on integer char codes instead of string characters.
**/
  public static function filterCharcode(s : String, predicate : Int -> Bool) {
    var codes : Array<Int> = toCharcodes(s).filter(predicate);
    return codes
      .map(function(i : Int) return String.fromCharCode(i))
      .join('');
  }

/**
`from` searches for the first occurrance of `searchFor` and returns the text from that point on.

If `searchFor` is not found, an empty string is returned.
**/
  public static function from(value : String, searchFor : String) {
    var pos = value.indexOf(searchFor);
    if (pos < 0)
      return "";
    else
      return value.substring(pos);
  }

  static var HASCODE_MAX : haxe.Int32 = 2147483647;
  static var HASCODE_MUL : haxe.Int32 = 31;
  public static function hashCode(value : String) {
    var code : haxe.Int32 = 0;
    for(i in 0...value.length) {
      var c : haxe.Int32 = value.charCodeAt(i);
      code = (HASCODE_MUL * code + c) % HASCODE_MAX;
    }
    return (code : Int);
  }

/**
Returns `true` if `value` is not `null` and contains at least one character.
**/
  public static inline function hasContent(value : String) : Bool
    return value != null && value.length > 0;

/**
Works the same as `underscore` but also replaces underscores with whitespaces.
**/
  public static function humanize(s : String)
    return underscore(s).replace('_', ' ');

/**
Checks if `s` contains only (and at least one) alphabetical characters.
**/
  public static function isAlpha(s : String)
    return s.length > 0 && !IS_ALPHA.match(s);

/**
`isAlphaNum` returns `true` if the string only contains alpha-numeric characters.
**/
  public static inline function isAlphaNum(value : String) : Bool
#if ( php && haxe_ver >=4.0)
  return  php.Syntax.code('ctype_alnum({0})',value);
#elseif (php && haxe_ver<4.0)
    return untyped __call__("ctype_alnum", value);
#else
    return ALPHANUM.match(value);
#end

  public static function isBreakingWhitespace(value : String) : Bool
    return !IS_BREAKINGWHITESPACE.match(value);

/**
Returns `true` if the value string is composed of only lower cased characters
or case neutral characters.
**/
  public static function isLowerCase(value : String) : Bool
    return value.toLowerCase() == value;

/**
Returns `true` if the value string is composed of only upper cased characters
or case neutral characters.
**/
  public static function isUpperCase(value : String) : Bool
    return value.toUpperCase() == value;

/**
`ifEmpty` returns `value` if it is neither `null` or empty, otherwise it returns `alt`
**/
  public static inline function ifEmpty(value : String, alt : String) : String
    return null != value && "" != value ? value : alt;

/**
`isDigitsOnly` returns `true` if the string only contains digits.
**/
  public static inline function isDigitsOnly(value : String) : Bool
  #if (php && haxe_ver>=4.0)
    return untyped php.Syntax.code('ctype_digit({0})',value);
#elseif (php && haxe_ver<4.0)
    return untyped __call__("ctype_digit", value);
#else
    return DIGITS.match(value);
#end

/**
`isEmpty` returns true if either `value` is null or is an empty string.
**/
  public static function isEmpty(value : String) : Bool
    return value == null || value == '';

/**
Convert first letter in `value` to lower case.
**/
  public static function lowerCaseFirst(value : String) : String
    return value.substring(0, 1).toLowerCase() + value.substring(1);

/**
Returns a random substring from the `value` argument. The length of such value is by default `1`.
**/
  public static function random(value : String, length = 1) {
    // var value = new UnicodeString(value);
    return value.substr(Math.floor((value.length - length + 1) * Math.random()), length);
  }

/**
Returns a random sampling of the specified length from the seed string.
**/
  public static function randomSequence(seed : String, length : Int) : String
    return Ints.range(0, length).map(function (_) return random(seed)).join("");

/**
Like `Strings.randomSequence`, but automatically uses `haxe.crypto.Base64.CHARS`
as the seed string.
**/
  public static function randomSequence64(length : Int) : String
    return randomSequence(haxe.crypto.Base64.CHARS, length);

/**
It returns an iterator holding in sequence one character of the string per iteration.
**/
  public static function iterator(s : String) : Iterator<String>
    return toArray(s).iterator();

/**
It maps a string character by character using `callback`.
**/
  public static function map<T>(value : String, callback : String -> T) : Array<T>
    return toArray(value).map(callback);

/**
If present, it removes all the occurrences of `toremove` from `value`.
**/
  inline public static function remove(value : String, toremove : String) : String
    return StringTools.replace(value, toremove, "");

/**
If present, it removes the `toremove` text from the end of `value`.
**/
  public static function removeAfter(value : String, toremove : String) : String
    return StringTools.endsWith(value, toremove) ? value.substring(0, value.length - toremove.length) : value;

/**
Removes a slice from `index` to `index + length` from `value`.
**/
  public static function removeAt(value : String, index : Int, length : Int) : String
    return value.substring(0, index) + value.substring(index + length);

/**
If present, it removes the `toremove` text from the beginning of `value`.
**/
  public static function removeBefore(value : String, toremove : String) : String
    return StringTools.startsWith(value, toremove) ? value.substring(toremove.length) : value;

/**
If present, it removes the first occurrence of `toremove` from `value`.
**/
  public static function removeOne(value : String, toremove : String) : String {
    var pos = value.indexOf(toremove);
    if(pos < 0)
      return value;
    return value.substring(0, pos) + value.substring(pos + toremove.length);
  }

/**
`repeat` builds a new string by repeating the argument `s`, n `times`.

```haxe
'Xy'.repeat(3); // generates 'XyXyXy'
```
**/
  public static function repeat(s : String, times : Int)
    return [for(i in 0...times) s].join('');

/**
Returns a new string whose characters are in reverse order.
**/
  public static function reverse(s : String) {
    var arr = toArray(s);
    arr.reverse();
    return arr.join("");
  }

/**
Converts a string in a quoted string.
**/
  public static function quote(s : String) {
    if (s.indexOf('"') < 0)
      return '"' + s + '"';
    else if (s.indexOf("'") < 0)
      return "'" + s + "'";
    else
      return '"' + StringTools.replace(s, '"', '\\"') + '"';
  }

/**
Like `StringTools.split` but it only splits on the first occurrance of separator.
**/
  public static function splitOnce(s : String, separator : String) {
    var pos = s.indexOf(separator);
    if(pos < 0)
      return [s];
    return [s.substring(0, pos), s.substring(pos + separator.length)];
  }

/**
Returns `true` if `s` starts with any of the values in `values`.
**/
  public static function startsWithAny(s : String, values : Iterable<String>) : Bool
    return Iterables.any(values, function(start) return s.startsWith(start));

/**
`stripTags` removes any HTML/XML markup from the string leaving only the concatenation
of the existing text nodes.
**/
  public static function stripTags(s : String) : String
 #if (php && haxe_ver>=4.0)
    return untyped php.Syntax.code('strip_tags({0})',s);
#elseif (php && haxe_ver<4.0)
    return untyped __call__("strip_tags", s);
#else
    return STRIPTAGS.replace(s, "");
#end

/**
Surrounds a string with the contents of `left` and `right`. If `right` is omitted,
`left` will be used on both sides;
*/
  inline public static function surround(s : String, left : String, ?right : String)
    return '$left$s${null==right?left:right}';

/**
It transforms a string into an `Array` of characters.
**/
  #if !(neko || php || eval) inline #end public static function toArray(s : String) {
    // #if (neko || php || eval)
    // var arr = [],
    //     len = new UnicodeString(s);
    // for(i in 0...s.length)
    //   arr.push(s.substr(i, 1));
    // return arr;
    // #else
    return s.split('');
    // #end
  }

/**
It transforms a string into an `Array` of char codes in integer format.
**/
  inline public static function toCharcodes(s : String) : Array<Int>
    return map(
      s,
      // function(s : String) return new UnicodeString(s).charCodeAt(0)
      function(s : String) return s.charCodeAt(0)
    );

/**
Returns an array of `String` whose elements are equally long (using `len`). If the string `s`
is not exactly divisible by `len` the last element of the array will be shorter.
**/
  public static function toChunks(s : String, len : Int) : Array<String> {
    var chunks = [];
        // s = new UnicodeString(s);
    while(s.length > 0) {
      chunks.push(s.substr(0, len));
      s = s.substr(len, s.length - len);
    }
    return chunks;
  }

/**
Returns an array of `String` split by line breaks.
**/
  inline public static function toLines(s : String)
    return SPLIT_LINES.split(s);

/**
`trimChars` removes from the beginning and the end of the string any character that is present in `charlist`.
**/
  public static inline function trimChars(value : String, charlist : String) : String
 #if (php && haxe_ver>=4.0)
    return untyped php.Global.trim('strip_tags({0})',s);
#elseif (php && haxe_ver<4.0)
    return untyped __call__("trim", value, charlist);
#else
    return trimCharsRight(trimCharsLeft(value, charlist), charlist);
#end

/**
`trimCharsLeft` removes from the beginning of the string any character that is present in `charlist`.
**/
  public static function trimCharsLeft(value : String, charlist : String) : String {
 #if (php && haxe_ver>=4.0)
    return untyped php.Global.ltrim(value,charlist);
#elseif (php && haxe_ver<4.0)
    return untyped __call__("ltrim", value, charlist);
#else
    var pos = 0;
    for(i in 0...value.length)
      if(contains(charlist, value.charAt(i)))
        pos++;
      else
        break;
    return value.substring(pos);
#end
  }

/**
`trimCharsRight` removes from the end of the string any character that is present in `charlist`.
**/
  public static function trimCharsRight(value : String, charlist : String) : String {
 #if (php && haxe_ver>=4.0)
    return untyped php.Global.rtrim(value,charlist);
#elseif (php && haxe_ver<4.0)
    return untyped __call__("rtrim", value, charlist);
#else
    var len = value.length,
        pos = len,
        i;
    for(j in 0...len) {
      i = len - j - 1;
      if(contains(charlist, value.charAt(i)))
        pos = i;
      else
        break;
    }
    return value.substring(0, pos);
#end
  }

/**
`underscore` finds UpperCase characters and turns them into LowerCase and prepends them with a whtiespace.
Sequences of more than one UpperCase character are left untouched.
**/
  public static function underscore(s : String) {
    s = (~/::/g).replace(s, '/');
    s = (~/([A-Z]+)([A-Z][a-z])/g).replace(s, '$1_$2');
    s = (~/([a-z\d])([A-Z])/g).replace(s, '$1_$2');
    s = (~/-/g).replace(s, '_');
    return s.toLowerCase();
  }

/**
Convert first letter in `value` to upper case.
**/
  public static function upperCaseFirst(value : String) : String
    return value.substring(0, 1).toUpperCase() + value.substring(1);

/**
`upTo` searches for the first occurrance of `searchFor` and returns the text up to that point.

If `searchFor` is not found, the entire string is returned.
**/
  public static function upTo(value : String, searchFor : String) {
    var pos = value.indexOf(searchFor);
    if (pos < 0)
      return value;
    else
      return value.substring(0, pos);
  }

/**
`wrapColumns` splits a long string into lines that are at most `columns` long.

Words whose length exceeds `columns` are not split.
**/
  public static function wrapColumns(s : String, columns = 78, indent = "", newline = "\n")
    return SPLIT_LINES.split(s).map(function(part)
        return wrapLine(
            StringTools.trim(WSG.replace(part, " ")),
            columns, indent, newline)
      ).join(newline);

  static function upperMatch(re : EReg)
    return re.matched(0).toUpperCase();

  static function wrapLine(s : String, columns : Int, indent : String, newline : String) {
    var parts = [],
        pos   = 0,
        len   = s.length,
        ilen  = indent.length;
    columns -= ilen;
    while(true) {
      if(pos + columns >= len - ilen) {
        parts.push(s.substring(pos));
        break;
      }

      var i = 0;
      while(!StringTools.isSpace(s, pos + columns - i) && i < columns)
        i++;
      if(i == columns) {
        // search ahead
        i = 0;
        while(!StringTools.isSpace(s, pos + columns + i) && pos + columns + i < len)
          i++;
        parts.push(s.substring(pos, pos + columns + i));
        pos += columns + i + 1;
      } else {
        parts.push(s.substring(pos, pos + columns - i));
        pos += columns - i + 1;
      }
    }

    return indent + parts.join(newline + indent);
  }

  public static function lpad(s : String, char : String, length : Int) {
    // var s = new UnicodeString(s);
    var diff = length - s.length;
    if(diff > 0) {
      return repeat(char, diff) + s;
    } else {
      return s;
    }
  }

  public static function rpad(s : String, char : String, length : Int) {
    // var s = new UnicodeString(s);
    var diff = length - s.length;
    if(diff > 0) {
      return s + repeat(char, diff);
    } else {
      return s;
    }
  }

  public static var monoid(default, never): Monoid<String> =
    { zero: "", append: function(a: String, b: String) return a + b }

  static var UCWORDS = ~/[^a-zA-Z]([a-z])/g;
  static var IS_BREAKINGWHITESPACE = ~/[^\t\n\r ]/;
  static var IS_ALPHA = ~/[^a-zA-Z]/;
#if !php
  static var UCWORDSWS = ~/[ \t\r\n][a-z]/g;
  static var ALPHANUM = ~/^[a-z0-9]+$/i;
  static var DIGITS = ~/^[0-9]+$/;
  static var STRIPTAGS = ~/<\/?[a-z]+[^>]*>/gi;
#end
  static var WSG = ~/[ \t\r\n]+/g;
  static var SPLIT_LINES = ~/\r\n|\n\r|\n|\r/g;
  static var CANONICALIZE_LINES = ~/\r\n|\n\r|\r/g;
}
