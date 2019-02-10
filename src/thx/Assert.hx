package thx;

import haxe.PosInfos;
import haxe.io.Bytes;

/**
This class contains only static members used to perform assertions.
Its use is straight forward:
```haxe
Assert.equals(1, 0); // fails
Assert.isFalse(1 == 1, "guess what?"); // fails and log the passed message
Assert.isTrue(true); // successfull
```

The default behavior for `Assert` static methods is determined by the
implementation of `Assert.behavior` and defaults to `thx.DefaultAssertBehavior`.

If you want to entirely remove assertions from your generated output, just add
the directive `-D no-asserts` (useful for production builds).
*/
class Assert {
  #if !no_asserts
  public static var behavior : IAssertBehavior = new DefaultAssertBehavior();
  #end

/**
Checks that the test value matches at least one of the possibilities.
@param possibility: An array of possible matches
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function contains<T>(possibilities : Array<T>, value : T, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(Arrays.contains(possibilities, value)) {
      pass(msg, pos);
    } else {
      fail(msg == null ? 'value $value not found in the expected possibilities $possibilities' : msg, pos);
    }
    #end
  }

/**
Asserts successfully when the value parameter is equal to the expected one.
```haxe
Assert.equals(10, age);
```
@param expected: The expected value to check against
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function equals(expected : Dynamic, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(msg == null) msg = 'expected $expected but it is $value';
    isTrue(expected == value, msg, pos);
    #end
  }

/**
Checks that the test array does not contain the match parameter.
@param match: The element that must NOT be included in the tested array
@param values: The values to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function excludes<T>(match : T, values : Array<T>, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(!Arrays.contains(values, match)) {
      pass(msg, pos);
    } else {
      fail(msg == null ? 'values $values do contain $match' : msg, pos);
    }
    #end
  }

/**
Forces a failure.
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function fail(msg = "failure expected", ?pos : PosInfos) {
    #if !no_asserts
    isTrue(false, msg, pos);
    #end
  }

/**
Checks that the test array contains the match parameter.
@param match: The element that must be included in the tested array
@param values: The values to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isContainedIn<T>(match : T, values : Array<T>, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(Arrays.contains(values, match)) {
      pass(msg, pos);
    } else {
      fail(msg == null ? 'values $values do not contain $match' : msg, pos);
    }
    #end
  }

/**
Asserts successfully when the condition is false.
@param cond: The condition to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isFalse(value : Bool, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if (null == msg)
      msg = "expected false";
    isTrue(value == false, msg, pos);
    #end
  }

/**
Asserts successfully when the 'value' parameter is of the of the passed `type`.
@param value: The value to test
@param type: The type to test against
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function is(value : Dynamic, type : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if (msg == null) msg = 'expected type ${Types.anyValueToString(type)} but it is ${Types.valueTypeToString(value)}';
    isTrue(Std.is(value, type), msg, pos);
    #end
  }

/**
Asserts successfully when the value is null.
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isNull(value : Dynamic, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if (msg == null)
      msg = 'expected null but it is $value';
    isTrue(value == null, msg, pos);
    #end
  }

/**
Asserts successfully when the condition is true.
@param cond: The condition to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function isTrue(cond : Bool, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if(cond)
      behavior.success(pos);
    else
      behavior.fail(msg, pos);
    #end
  }

/**
Asserts successfully when the value parameter does match against the passed EReg instance.
```haxe
Assert.match(~/x/i, "haXe");
```
@param pattern: The pattern to match against
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function matches(pattern : EReg, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(msg == null) msg = 'the value $value does not match the provided pattern';
    isTrue(pattern.match(value), msg, pos);
    #end
  }

/**
Same as Assert.equals but accounting for an approximation error.
```haxe
Assert.nearEquals(Math.PI, value);
```
@param expected: The expected value to check against
@param value: The value to test
@param approx: The approximation tollerance. Default is 1e-5
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function nearEquals(expected : Float, value : Float, ?approx : Float, ?msg : String , ?pos : PosInfos) : Void {
    #if !no_asserts
    if (msg == null) msg = 'expected $expected but it is $value';
    return isTrue(Floats.nearEquals(expected, value, approx), msg, pos);
    #end
  }

/**
Asserts successfully when the value parameter is not the same as the expected one.
```haxe
Assert.notEquals(10, age);
```
@param expected: The expected value to check against
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function notEquals(expected : Dynamic, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(msg == null) msg = 'expected $expected and test value $value should be different';
    isFalse(expected == value, msg, pos);
    #end
  }

/**
Asserts successfully when the value is not null.
@param value: The value to test
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function notNull(value : Dynamic, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    if (null == msg)
      msg = "expected not null";
    isTrue(value != null, msg, pos);
    #end
  }

/**
Adds a successful assertion for cases where there are no values to assert.
@param msg: An optional success message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function pass(msg = "pass expected", ?pos : PosInfos) {
    #if !no_asserts
    isTrue(true, msg, pos);
    #end
  }

/**
It is used to test an application that under certain circumstances must
react throwing an error. This assert guarantees that the error is of the
correct type (or Dynamic if non is specified).
```haxe
Assert.raises(function() { throw "Error!"; }, String);
```
@param method: A method that generates the exception.
@param type: The type of the expected error. Defaults to Dynamic (catch all).
@param msgNotThrown: An optional error message used when the function fails to raise the expected
     exception. If not passed a default one will be used
@param msgWrongType: An optional error message used when the function raises the exception but it is
     of a different type than the one expected. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function raises(method:Void -> Void, ?type : Dynamic, ?msgNotThrown : String , ?msgWrongType : String, ?pos : PosInfos) {
    #if !no_asserts
    try {
      method();
      if (null == msgNotThrown) {
        var name = null == type ? "Dynamic" : Types.anyValueToString(type);
        msgNotThrown = 'exception of type $name not raised';
      }
      fail(msgNotThrown, pos);
    } catch (ex : Dynamic) {
      if(null == type) {
        pass(pos);
      } else {
        if (null == msgWrongType) {
          var name = Types.anyValueToString(type);
          msgWrongType = 'expected throw of type $name but it is $ex';
        }
        isTrue(Std.is(ex, type), msgWrongType, pos);
      }
    }
    #end
  }

/**
Check that value is an object with the same fields and values found in expected.
The default behavior is to check nested objects in fields recursively.
```haxe
Assert.same({ name : "utest"}, ob);
```
@param expected: The expected value to check against
@param value: The value to test
@param recursive: States whether or not the test will apply also to sub-objects.
Defaults to true
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function same(expected : Dynamic, value : Dynamic, ?recursive : Bool = true, ?msg : String, ?pos : PosInfos) {
    #if !no_asserts
    var status = { recursive : recursive, path : '', error : null };
    if(sameAs(expected, value, status)) {
      pass(msg, pos);
    } else {
      fail(msg == null ? status.error : msg, pos);
    }
    #end
  }

/**
Checks that the expected values is contained in value.
@param match: the string value that must be contained in value
@param value: the value to test
@param msg: An optional error message. If not passed a default one is be used
@param pos: Code position where the Assert call has been executed.
*/
  #if no_asserts inline #end
  public static function stringContains(match : String, value : String, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if (value != null && value.indexOf(match) >= 0) {
      pass(msg, pos);
    } else {
      fail(msg == null ? 'value ${Strings.quote(value)} does not contain ${Strings.quote(match)}' : msg, pos);
    }
    #end
  }

/**
Checks that the test string contains all the values in `sequence` in the order
they are defined.
@param sequence: the values to match in the string
@param value: the value to test
@param msg: An optional error message. If not passed a default one is be used
@param pos: Code position where the Assert call has been executed.
*/
  #if no_asserts inline #end
  public static function stringSequence(sequence : Array<String>, value : String, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if (null == value) {
      fail(msg == null ? "null argument value" : msg, pos);
      return;
    }
    var p = 0;
    for (s in sequence) {
      var p2 = value.indexOf(s, p);
      if (p2 < 0) {
        if (msg == null) {
          msg = 'expected ${Strings.quote(s)} after ';
          if (p > 0) {
            msg += ' ${Strings.quote(Strings.ellipsis(value, 30))}';
          } else
            msg += " begin";
        }
        fail(msg, pos);
        return;
      }
      p = p2 + s.length;
    }
    pass(msg, pos);
    #end
  }

/**
Creates a warning message.
@param msg: A mandatory message that justifies the warning.
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
*/
  #if no_asserts inline #end
  public static function warn(msg, ?pos : haxe.PosInfos) {
    #if !no_asserts
    behavior.warn(msg, pos);
    #end
  }

// helper methods
  static function sameAs(expected : Dynamic, value : Dynamic, status : SameStatus) {
    function withPath(msg : String) {
      return msg + (Strings.isEmpty(status.path) ? '' : ' at ${status.path}');
    }
    if(!Types.sameType(expected, value)) {
      var texpected = Types.valueTypeToString(expected),
          tvalue = Types.valueTypeToString(value);
      status.error = withPath('expected type $texpected but it is $tvalue');
      return false;
    }
    switch Type.typeof(expected) {
      case TFloat:
        if (!Floats.nearEquals(expected, value)) {
          status.error = withPath('expected $expected but it is $value');
          return false;
        }
        return true;
      case TNull, TInt, TBool:
        if(expected != value) {
          status.error = withPath('expected $expected but it is $value');
          return false;
        }
        return true;
      case TFunction:
        if (!Reflect.compareMethods(expected, value)) {
          status.error = withPath("expected same function reference");
          return false;
        }
        return true;
      case TClass(c):
        // string
        if (Std.is(expected, String)) {
          if(expected == value) {
            return true;
          } else {
            status.error = withPath('expected ${Strings.quote(expected)} but it is ${Strings.quote(value)}');
            return false;
          }
        }

        // arrays
        if(Std.is(expected, Array)) {
          if(status.recursive || status.path == '') {
            if(expected.length != value.length) {
              status.error = withPath('expected ${expected.length} elements but they are ${value.length}');
              return false;
            }
            var path = status.path;
            for(i in 0...expected.length) {
              status.path = path == '' ? 'array[$i]' : path + '[$i]';
              if (!sameAs(expected[i], value[i], status))
              {
                status.error = withPath('expected ${Std.string(expected[i])} but it is ${Std.string(value[i])}');
                return false;
              }
            }
          }
          return true;
        }

        // date
        if(Std.is(expected, Date)) {
          if((expected : Date).getTime() != (value : Date).getTime()) {
            status.error = withPath('expected $expected but it is $value');
            return false;
          }
          return true;
        }

        // bytes
        if(Std.is(expected, Bytes)) {
          if(status.recursive || status.path == '') {
            var ebytes : Bytes = expected,
                vbytes : Bytes = value;
            if (ebytes.length != vbytes.length) return false;
            for (i in 0...ebytes.length)
              if (ebytes.get(i) != vbytes.get(i)) {
                status.error = withPath('expected byte ${ebytes.get(i)} but it is ${vbytes.get(i)}');
                return false;
              }
          }
          return true;
        }

        // hash, inthash
        if (Std.is(expected, #if (haxe_ver >= 3.200) haxe.Constraints.IMap #else Map.IMap #end)) {
          if(status.recursive || status.path == '') {
            var map = cast(expected, Map<Dynamic, Dynamic>),
                vmap = cast(value, Map<Dynamic, Dynamic>),
                keys : Array<Dynamic> = [for (k in map.keys()) k],
                vkeys : Array<Dynamic> = [for (k in vmap.keys()) k];

            if(keys.length != vkeys.length) {
              status.error = withPath('expected ${keys.length} keys but they are ${vkeys.length}');
              return false;
            }
            var path = status.path;
            for(key in keys) {
              status.path = path == '' ? 'hash[$key]' : path + '[$key]';
              if (!sameAs(map.get(key), vmap.get(key), status)) {
                status.error = withPath('expected $expected but it is $value');
                return false;
              }
            }
          }
          return true;
        }

        // iterator
        if(Iterators.isIterator(expected)) {
          if(status.recursive || status.path == '') {
            var evalues = Iterators.toArray(expected),
                vvalues = Iterators.toArray(value);
            if(evalues.length != vvalues.length) {
              status.error = withPath('expected ${evalues.length} values in Iterator but they are ${vvalues.length}');
              return false;
            }
            var path = status.path;
            for(i in 0...evalues.length) {
              status.path = path == '' ? 'iterator[$i]' : path + '$path[$i]';
              if (!sameAs(evalues[i], vvalues[i], status)) {
                status.error = withPath('expected $expected but it is $value');
                return false;
              }
            }
          }
          return true;
        }

        // iterable
        if(Iterables.isIterable(expected)) {
          if(status.recursive || status.path == '') {
            var evalues = Iterables.toArray(expected),
                vvalues = Iterables.toArray(value);
            if(evalues.length != vvalues.length) {
              status.error = withPath('expected ${evalues.length} values in Iterable but they are ${vvalues.length}');
              return false;
            }
            var path = status.path;
            for(i in 0...evalues.length) {
              status.path = path == '' ? 'iterable[$i]' : path + '[$i]';
              if(!sameAs(evalues[i], vvalues[i], status))
                return false;
            }
          }
          return true;
        }

        // custom class
        if(status.recursive || status.path == '') {
          var fields = Type.getInstanceFields(Type.getClass(expected)),
              path = status.path;
          for(field in fields) {
            status.path = path == '' ? field : '$path.$field';
            var e = Reflect.field(expected, field);
            if(Reflect.isFunction(e)) continue;
            var v = Reflect.field(value, field);
            if(!sameAs(e, v, status))
              return false;
          }
        }

        return true;
      case TEnum(e) :
        var eexpected = Type.getEnumName(e),
            evalue = Type.getEnumName(Type.getEnum(value));
        if (eexpected != evalue) {
          status.error = withPath('expected enumeration of $eexpected but it is $evalue');
          return false;
        }
        if (status.recursive || status.path == '') {
          if (Type.enumIndex(expected) != Type.enumIndex(value)) {
            status.error = withPath('expected ${Type.enumConstructor(expected)} but it is ${Type.enumConstructor(value)}');
            return false;
          }
          var eparams = Type.enumParameters(expected),
              vparams = Type.enumParameters(value),
              path = status.path;
          for (i in 0...eparams.length) {
            status.path = path == '' ? 'enum[$i]' : path + '[$i]';
            if (!sameAs(eparams[i], vparams[i], status)) {
              status.error = withPath('expected $expected but it is $value');
              return false;
            }
          }
        }
        return true;
      case TObject:
        // anonymous object
        if(status.recursive || status.path == '') {
          var tfields = Reflect.fields(value),
              fields = Reflect.fields(expected),
              path = status.path;
          for(field in fields) {
            tfields.remove(field);
            status.path = path == '' ? field : '$path.$field';
            if(!Reflect.hasField(value, field)) {
              status.error = withPath('expected field ${status.path} does not exist in $value');
              return false;
            }
            var e = Reflect.field(expected, field);
            if(Reflect.isFunction(e))
              continue;
            var v = Reflect.field(value, field);
            if(!sameAs(e, v, status))
              return false;
          }
          if(tfields.length > 0) {
            status.error = withPath('the tested object has extra field(s) (${tfields.join(", ")}) not included in the expected ones');
            return false;
          }
        }

        // iterator
        if(Iterators.isIterator(expected)) {
          if(!(Iterators.isIterator(value))) {
            status.error = withPath('expected an Iterable');
            return false;
          }
          if(status.recursive || status.path == '') {
            var evalues = Iterators.toArray(expected),
                vvalues = Iterators.toArray(value);
            if(evalues.length != vvalues.length) {
              status.error = withPath('expected ${evalues.length} values in Iterator but they are ${vvalues.length}');
              return false;
            }
            var path = status.path;
            for(i in 0...evalues.length) {
              status.path = path == '' ? 'iterator[$i]' : path + '[$i]';
              if (!sameAs(evalues[i], vvalues[i], status)) {
                status.error = withPath('expected $expected but it is $value');
                return false;
              }
            }
          }
          return true;
        }

        // iterable
        if(Iterables.isIterable(expected)) {
          if(!(Iterables.isIterable(value))) {
            status.error = withPath('expected an Iterator');
            return false;
          }
          if(status.recursive || status.path == '') {
            var evalues = Iterables.toArray(expected),
                vvalues = Iterables.toArray(value);
            if(evalues.length != vvalues.length) {
              status.error = withPath('expected ${evalues.length} values in Iterable but they are ${vvalues.length}');
              return false;
            }
            var path = status.path;
            for(i in 0...evalues.length) {
              status.path = path == '' ? 'iterable[$i]' : path + '[$i]';
              if(!sameAs(evalues[i], vvalues[i], status))
                return false;
            }
          }
          return true;
        }
        return true;
      case TUnknown :
        return throw "Unable to compare two unknown types";
    }
    return throw 'Unable to compare values: $expected and $value';
  }
}

/**
Defines a protocol to interact with the `thx.Assert` static methods.

To use a custom `IAssertBehavior` with `Assert` simply assing your instance to
`thx.Assert.behavior`.
*/
interface IAssertBehavior {
  function success(pos : PosInfos) : Void;
  function fail(message : String, pos : PosInfos) : Void;
  function warn(message : String, pos : PosInfos) : Void;
}

#if !no_asserts
/**
Defines the defaiult behavior when `thx.Assert` static methods are invoked.

  * Failures throw exceptions of type `thx.error.AssertError`.
  * Successes do nothing or trace messages if `-D trace-asserts` is defined.
  * Warnings go directly to trace.
*/
class DefaultAssertBehavior implements IAssertBehavior {
  public function new() {}

  public function success(pos : PosInfos) {
    #if trace_asserts
    haxe.Log.trace('assert success', pos);
    #end
  }

  public function warn(message : String, pos : PosInfos)
    haxe.Log.trace(message, pos);

  public function fail(message : String, pos : PosInfos)
    throw new thx.error.AssertError(message, pos);
}

private typedef SameStatus = {
  recursive : Bool,
  path : String,
  error : String
};
#end
