package thx;

using StringTools;
using thx.Arrays;

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
`capitalize` returns a string with the first character convert to upper case.
**/
  inline public static function capitalize(s : String)
    return s.substring(0, 1).toUpperCase() + s.substring(1);

/**
Capitalize the first letter of every word in `value`. If `whiteSpaceOnly` is set to `true`
the process is limited to whitespace separated words.
**/
  public static function capitalizeWords(value : String, ?whiteSpaceOnly = false) : String {
    if(whiteSpaceOnly) {
#if php
      return untyped __call__("ucwords", value);
#else
      return UCWORDSWS.map(capitalize(value), upperMatch);
#end
    } else {
      return UCWORDS.map(capitalize(value), upperMatch);
    }
  }

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
  public static function compare(a : String, b : String)
    return a < b ? -1 : a > b ? 1 : 0;

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
`contains` returns `true` if `s` contains any of the strings in `tests`
**/
  inline public static function containsAny(s : String, tests : Array<String>)
    return tests.any(contains.bind(s, _));


/**
`dasherize` replaces all the occurrances of `_` with `-`;
**/
  public static function dasherize(s : String)
    return s.replace('_', '-');

/**
`ellipsis` truncates `s` at len `maxlen` replaces the last characters with the content
of `symbol`.

```haxe
'thx is a nice library'.ellipsis(8); // returns 'thx is …'
```
**/
  public static function ellipsis(s : String, maxlen = 20, symbol = "…")
    return if (s.length > maxlen)
      s.substring(0, maxlen - symbol.length) + symbol;
    else
      s;

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
  public static function filterCharcode(s : String, predicate : Int -> Bool)
    return toCharcodeArray(s)
      .filter(predicate)
      .map(function(i) return String.fromCharCode(i))
      .join('');

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

/**
Works the same as `underscore` but also replaces underscores with whitespaces.
**/
  public static function humanize(s : String)
    return underscore(s).replace('_', ' ');

/**
`isAlphaNum` returns `true` if the string only contains alpha-numeric characters.
**/
  public static inline function isAlphaNum(value : String) : Bool
#if php
    return untyped __call__("ctype_alnum", value);
#else
    return ALPHANUM.match(value);
#end

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
#if php
    return untyped __call__("ctype_digit", value);
#else
    return DIGITS.match(value);
#end

/**
`isEmpty` returns true if either `value` is null or is an empty string.
**/
  public static function isEmpty(value : String)
    return value == null || value == '';

/**
Returns a random substring from the `value` argument. The length of such value is by default `1`.
**/
  public static function random(value : String, length = 1)
    return value.substr(Math.floor((value.length - length + 1) * Math.random()), length);

/**
It returns an iterator holding in sequence one character of the string per iteration.
**/
  public static function iterator(s : String) : Iterator<String>
    return s.split('').iterator();

/**
It maps a string character by character using `callback`.
**/
  public static function map<T>(value : String, callback : String -> T) : Array<T>
    return toArray(value).map(callback);

/**
If present, it removes all the occurrencies of `toremove` from `value`.
**/
  inline public static function remove(value : String, toremove : String) : String
    return StringTools.replace(value, toremove, "");


/**
If present, it removes the `toremove` text from the end of `value`.
**/
  public static function removeAfter(value : String, toremove : String) : String
    return StringTools.endsWith(value, toremove) ? value.substring(0, value.length - toremove.length) : value;

/**
If present, it removes the `toremove` text from the beginning of `value`.
**/
  public static function removeBefore(value : String, toremove : String) : String
    return StringTools.startsWith(value, toremove) ? value.substring(toremove.length) : value;

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
    var arr = s.split("");
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
`stripTags` removes any HTML/XML markup from the string leaving only the concatenation
of the existing text nodes.
**/
  public static function stripTags(s : String) : String
#if php
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
  inline public static function toArray(s : String)
    return s.split('');

/**
It transforms a string into an `Array` of char codes in integer format.
**/
  inline public static function toCharcodeArray(s : String) : Array<Int>
    return map(s, function(s : String)
        // the cast is required to compile safely to C#
        return (s.charCodeAt(0) : Int));

/**
Returns an array of `String` whose elements are equally long (using `len`). If the string `s`
is not exactly divisible by `len` the last element of the array will be shorter.
**/
  public static function toChunks(s : String, len : Int) : Array<String> {
    var chunks = [];
    while(s.length > 0) {
      chunks.push(s.substring(0, len));
      s = s.substring(len);
    }
    return chunks;
  }

/**
`trimChars` removes from the beginning and the end of the string any character that is present in `charlist`.
**/
  public static inline function trimChars(value : String, charlist : String) : String
#if php
    return untyped __call__("trim", value, charlist);
#else
    return trimCharsRight(trimCharsLeft(value, charlist), charlist);
#end

/**
`trimCharsLeft` removes from the beginning of the string any character that is present in `charlist`.
**/
  public static function trimCharsLeft(value : String, charlist : String) : String {
#if php
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
#if php
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
      pos = 0,
      len = s.length,
      ilen = indent.length;
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

  static var UCWORDS = ~/[^a-zA-Z]([a-z])/g;
#if !php
  static var UCWORDSWS = ~/[ \t\r\n][a-z]/g;
  static var ALPHANUM = ~/^[a-z0-9]+$/i;
  static var DIGITS = ~/^[0-9]+$/;
  static var STRIPTAGS = ~/<\/?[a-z]+[^>]*>/gi;
#end
  static var WSG = ~/[ \t\r\n]+/g;
  static var SPLIT_LINES = ~/\r\n|\n\r|\n|\r/g;
}

/** Alias of `StringTools`, included so mixins work with `using thx.Strings;` **/
typedef HaxeStringTools = StringTools;
