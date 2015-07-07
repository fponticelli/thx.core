package thx;

import haxe.PosInfos;

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
  public static function containedIn<T>(possibilities : Array<T>, value : T, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(Arrays.contains(possibilities, value)) {
      isTrue(true, msg, pos);
    } else {
      fail(msg == null ? 'value $value not found in the expected possibilities $possibilities' : msg, pos);
    }
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
  public static function contains<T>(match : T, values : Array<T>, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(Arrays.contains(values, match)) {
      isTrue(true, msg, pos);
    } else {
      fail(msg == null ? 'values $values do not contain $match' : msg, pos);
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
    if(msg == null) msg = 'expected $expected but was $value';
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
      isTrue(true, msg, pos);
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
Same as Assert.equals but considering an approximation error.
```haxe
Assert.floatEquals(Math.PI, value);
```
@param expected: The expected value to check against
@param value: The value to test
@param approx: The approximation tollerance. Default is 1e-5
@param msg: An optional error message. If not passed a default one will be used
@param pos: Code position where the Assert call has been executed. Don't fill it
unless you know what you are doing.
@todo test the approximation argument
*/
  #if no_asserts inline #end
  public static function floatEquals(expected : Float, value : Float, ?approx : Float, ?msg : String , ?pos : PosInfos) : Void {
    #if !no_asserts
    if (msg == null) msg = 'expected $expected but was $value';
    return isTrue(Floats.nearEquals(expected, value, approx), msg, pos);
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
    if (msg == null) msg = 'expected type ${Types.toString(type)} but was ${Types.valueTypeToString(value)}';
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
      msg = 'expected null but was $value';
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
  public static function match(pattern : EReg, value : Dynamic, ?msg : String , ?pos : PosInfos) {
    #if !no_asserts
    if(msg == null) msg = 'the value $value does not match the provided pattern';
    isTrue(pattern.match(value), msg, pos);
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
@todo test the optional type parameter
*/
  #if no_asserts inline #end
  public static function raises(method:Void -> Void, ?type : Dynamic, ?msgNotThrown : String , ?msgWrongType : String, ?pos : PosInfos) {
    #if !no_asserts
    try {
      method();
      if (null == msgNotThrown) {
        var name = Types.toString(type);
        msgNotThrown = 'exception of type $name not raised';
      }
      fail(msgNotThrown, pos);
    } catch (ex : Dynamic) {
      if (null == msgWrongType) {
        var name = Types.toString(type);
        msgWrongType = 'expected throw of type $name but was $ex';
      }
      if(null == type) {
        pass(pos);
      } else {
        isTrue(Std.is(ex, type), msgWrongType, pos);
      }
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
      isTrue(true, msg, pos);
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
        if (msg == null)
        {
          msg = 'expected ${Strings.quote(s)} after ';
          if (p > 0) {
            var cut = value.substr(0, p);
            if (cut.length > 30)
              cut = '...' + cut.substr( -27);
            msg += ' ${Strings.quote(cut)}';
          } else
            msg += " begin";
        }
        fail(msg, pos);
        return;
      }
      p = p2 + s.length;
    }
    isTrue(true, msg, pos);
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
}

interface IAssertBehavior {
  function success(pos : PosInfos) : Void;
  function fail(message : String, pos : PosInfos) : Void;
  function warn(message : String, pos : PosInfos) : Void;
}

#if !no_asserts
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
#end
